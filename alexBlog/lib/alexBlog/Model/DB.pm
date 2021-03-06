package alexBlog::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'alexBlog::Schema',
    
    connect_info => {
        dsn => 'dbi:mysql:Catalyst',
        user => 'root',
        password => 'mona',
        AutoCommit => q{1},
    }
);

=head1 NAME

alexBlog::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<alexBlog>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<alexBlog::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

mona

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
