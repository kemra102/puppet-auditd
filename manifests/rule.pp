## params:
##   content: Rule definition.
##   order: Relative order of this rule.

define auditd::rule (

  Stdlib::Absolutepath $rules_file,

  String $content = '',
  Integer $order = 10

) {

  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  # Validate the $body
  validate_legacy('String', 'validate_string', $body)

  concat::fragment{ "auditd_fragment_${name}":
    target  => $rules_file,
    order   => $order,
    content => $body,
  }

}
