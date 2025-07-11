gtk_versions = [
  '3.0',
]

gtk_sucharu_colors_defs = {}
sass_global_paths = ['-I', meson.project_source_root() / 'common']
message('All flavours: @0@\n'.format(flavours))

foreach flavour: flavours
  suffix = flavour == 'default' ? '' : '-@0@'.format(flavour)
  theme_full_name = meson.project_name() + suffix
  is_dark = flavour == 'dark' or flavour.endswith('-dark')
  # is_darker = flavour == 'darker' or flavour.endswith('-darker')
  if is_dark
    base_theme_name = flavour.split('-dark')[0]
  # elif is_darker
  #   base_theme_name = flavour.split('-darker')[0]
  else
    base_theme_name = flavour
  endif
  message('Working on : ' + theme_full_name)
  # message('')
  is_accent = enabled_accent_colors.contains(base_theme_name)
  theme_dir = join_paths(get_option('datadir'), 'themes', theme_full_name)
  accent = is_accent ? base_theme_name : 'default'

  # if is_accent
    accent_configuration = {
      'sucharu_dark_variant': is_dark ? 'true' : 'false',
      'sucharu_accent_color': is_accent ? base_theme_name : 'default',
    }

    accent_info_css = configure_file(
      configuration: accent_configuration + {
        'sucharu_theme_entry_point': '/dev/null',
      },
      input: accent_colors_definitions_scss,
      output: '@0@-accent-color-info.scss'.format(theme_full_name),
    )

    accent_color_code = run_command(sassc,
      sass_global_paths,
      accent_info_css, check: true).stderr().split(' Accent color is ')[1].strip()
    assert(accent_color_code.startswith('#'), 'No accent color code found')
  # endif

  conf_data = configuration_data()
  conf_data.set('ThemeName', meson.project_name())
  conf_data.set('FlavourThemeName', theme_full_name)
  conf_data.set('IconThemeName', theme_full_name)
  conf_data.set('MetacityThemeName', is_dark ? '-'.join(meson.project_name(), 'dark') : meson.project_name())
  conf_data.set('DarkTheme', is_dark ? 'true' : 'false')
  conf_data.set('AccentName', is_accent ? base_theme_name : 'default')
  conf_data.set('AccentColor', is_accent ? accent_color_code : '')
  configure_file(input: 'index.theme.in',
    output: '@0@-index.theme'.format(theme_full_name),
    configuration: conf_data,
    install_dir: theme_dir
  )

  # build and install gtk data
  foreach gtk_ver: gtk_versions
    message('Working on GTK version ' + gtk_ver)
    gtk_dir = 'gtk-@0@'.format(gtk_ver)
    base_path = (flavour.startswith('mate') ? base_theme_name : 'default') / gtk_dir
    default_path = 'default' / gtk_dir
    upstream_path = '..' / 'upstream' / gtk_dir / 'Yaru'
    flavour_path = join_paths('flavours', accent, gtk_dir)
    install_path = theme_dir / gtk_dir

    # Sort by most relevant for the theme flavour
    sources_priority = [
      default_path,
    ]

    gtk_css = []
    generated_css = []
    sucharu_gtk_colors_defs = []
    variant = 'gtk'
    message('Configuring @0@ variant for @1@-@2@'.format(
      theme_full_name, variant, gtk_ver))
    target_name = '@0@-@1@'.format(theme_full_name, gtk_dir)
    if is_dark
      variant_file = variant.split('-dark')[0] + '-dark'
    # elif is_darker
    #   variant_file = variant.split('-darker')[0] + '-darker'
    else
      variant_file = variant
    endif
    gtk_scss_path = flavour_path / variant_file + '.scss'

    if not fs.is_file(gtk_scss_path)
      gtk_scss_path = base_path / variant_file + '.scss'
    endif

    # Look for scss files in the variant dir first, otherwise fallback to
    # base, default or upstream paths, so using reversed order
    scss_paths = sass_global_paths
    gtk_scss_dependencies = []
    foreach src: sources_priority
      scss_paths += ['-I', meson.current_source_dir() / src ]

      scss_deps = run_command(
        'find', src, '-name', '_*.scss', check: false
        ).stdout().strip().split('\n')
      if scss_deps.length() > 0 and scss_deps[0] != ''
        gtk_scss_dependencies += scss_deps
      endif
    endforeach

    # if is_accent
    gtk_accents_css = configure_file(
      configuration: accent_configuration + {
        'sucharu_theme_entry_point': meson.current_source_dir() / gtk_scss_path,
      },
      input: accent_colors_definitions_scss,
      output: '@0@-accent-colors.scss'.format(target_name),
    )

    gtk_scss_path = gtk_accents_css

    gtk_sucharu_colors_defs_scss = configure_file(
      configuration: accent_configuration + {
        'sucharu_theme_entry_point': sucharu_colors_defs_scss,
      },
      input: accent_colors_definitions_scss,
      output: '@0@-sucharu-colors-defs.scss'.format(target_name),
    )

    sucharu_gtk_colors_defs = custom_target(
      '@0@-sucharu-colors-definitions'.format(target_name),
      input: gtk_sucharu_colors_defs_scss,
      output: '@BASENAME@.css',
      command: [
        sassc, '-a',
        scss_paths,
        '@INPUT@', '@OUTPUT@',
      ],
      depend_files: [
        sucharu_colors_defs_scss,
        gtk_scss_dependencies,
      ]
    )
    # endif
    if gtk_ver == '3.0'
      gtk_sucharu_colors_defs += {theme_full_name: sucharu_gtk_colors_defs}
    endif
    
    generated_css += custom_target(target_name,
      input: gtk_scss_path,
      output: '@0@-generated.css'.format(target_name),
      depend_files: files(gtk_scss_dependencies),
      command: [
        sassc, '-a',
        scss_paths,
        '@INPUT@', '@OUTPUT@'],
    )
  endforeach
  message(flavour + ' completed.\n')
endforeach
