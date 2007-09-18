#!/usr/bin/perl

package Template::Declare::Anon;

use strict;
use warnings;

use base qw/Exporter/;

our $VERSION = "0.02";

use Template::Declare ();
use Template::Declare::Tags ();

use overload '""' => \&process;

our @EXPORT = qw( anon_template process );

sub anon_template (&) {
	my $self = shift;
	bless $self, __PACKAGE__;
}

sub process {
	my ( $template, @args ) = @_;

	local %Template::Declare::Tags::ELEMENT_ID_CACHE = ();
	local $Template::Declare::Tags::self = $Template::Declare::Tags::self || "Template::Declare";

	Template::Declare->new_buffer_frame;

	&$template($Template::Declare::Tags::self, @args);

	my $output = Template::Declare->buffer->data;

	Template::Declare->end_buffer_frame;

	return $output;
}

__PACKAGE__;

__END__

=pod

=head1 NAME

Template::Declare::Anon - Anonymous Template::Declare templates

=head1 SYNOPSIS

	use Template::Declare::Anon;
	use Template::Declare::Tags 'HTML';

	my $sub_template = anon_template {
		row {
			cell { "Hello, world!" }
		}
	};

	my $template = anon_template {
		link {}
		table { &$sub_template }
		img { attr { src => 'cat.gif' } }
	};

	print $template; # overload is OK

=head1 DESCRIPTION

L<Template::Declare> provides awesome *ML templating facilities. This module
allows to use this language with anonymous templates, for more ad hoc purposes.

=head1 FUNCTIONS

=over 4

=item anon_template &template

Declare an anonymous template

=item process $template, @args

Process an anonymous template with the arguments @args.

=back

=head1 OVERLOADS

=over 4

=item "" (stringification)

Equivalent to C<process> with no arguments.

=back

=head1 TODO

=over 4

=item Tagsets

Allow exporting of tagsets like L<Template::Declare::Tags> does (C<HTML> etc)
without needing the other exports of L<Template::Declare::Tags>.

=back

=head1 SEE ALSO

L<Template::Declare>

=head1 AUTHOR

Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT & LICENSE

	Copyright (c) 2007 Yuval Kogman. All rights reserved
	This program is free software; you can redistribute it and/or modify it
	under the terms of the MIT license or the same terms as Perl itself.

=cut
