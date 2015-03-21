# == Define: types::mknod
#
define types::mknod (
  $ensure                  = present,
  $mode                    = 0444,
  $type                    = undef,
  $major                   = undef,
  $minor                   = undef,
) {

  # validate params
  validate_re($ensure, '^(present)|(absent)$',
    "types::file::${name}::ensure must be 'present' or 'absent'.")
  validate_absolute_path($name)
  validate_re($mode, '^\d{4}$', "types::mknod::${name}::mode must be exactly 4 digits.")
  validate_re($type, '^(b|c|w)$', "types::mknod::${name}::type must be 'b', 'c' or 'w'.")
  validate_re($major, '^\d+$', "types::mknod::${name}::major must be an integer.")
  validate_re($minor, '^\d+$', "types::mknod::${name}::minor must be an integer.")

  if $ensure =~ /^(absent)$/ {
    exec { "rm-${name}":
      command => "/bin/rm -f ${name}",
      onlyif => "/usr/bin/test -c ${name}",
    }
  } elsif $ensure =~ /^(present)$/ {
    exec { "mknod-${name}":
      command => "/bin/mknod -m ${mode} ${name} ${type} ${major} ${minor}",
      unless => "/usr/bin/test -c ${name}",
    }
  }
}
