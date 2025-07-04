project('Sucharu',
        version: '0.1.5',
        meson_version: '>= 1.3.0',
        license : ['GPL3', 'CC BY-SA 4.0'],
        default_options: ['prefix=/usr'])

fs = import('fs')
gnome = import('gnome')

python = find_program('python3')
sassc = find_program('sassc')

subdir('common')

components = [
  'gtk',
  'icons',
  # 'cursors'
]

enabled_accent_colors = get_option('accent-colors')

foreach component: components
  if not get_option(component)
    message('skip component ' + component)
    continue
  endif

  message('\n\tBuilding component ' + component)
  subdir(component)

endforeach
