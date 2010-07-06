package MooseX::PrivateSetters;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose 0.84 ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::PrivateSetters::Role::Attribute;

# The main reason to use this is to ensure that we get the right value
# in $p{for_class} later.
Moose::Exporter->setup_import_methods();

sub init_meta
{
    shift;
    my %p = @_;

    Moose->init_meta(%p);

    return
        Moose::Util::MetaRole::apply_metaclass_roles
            ( for_class => $p{for_class},
              attribute_metaclass_roles =>
              ['MooseX::PrivateSetters::Role::Attribute'],
            );
}

1;

__END__

=pod

=head1 NAME

MooseX::PrivateSetters - Name your accessors foo() and _set_foo()

=head1 SYNOPSIS

    use MooseX::PrivateSetters;
    use Moose;

    # make some attributes

=head1 DESCRIPTION

This module does not provide any methods. Simply loading it changes
the default naming policy for the loading class so that accessors are
separated into get and set methods. The get methods have the same name
as the accessor, while set methods are prefixed with "_set_".

If you define an attribute with a leading underscore, then the set
method will start with "_set_".

If you explicitly set a "reader" or "writer" name when creating an
attribute, then that attribute's naming scheme is left unchanged.

=head1 AUTHOR

brian greenfield, C<< <briang@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-privatesetters@rt.cpan.org>, or through the web interface
at L<http://rt.cpan.org>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2010 brian greenfield

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
