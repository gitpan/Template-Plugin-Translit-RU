#============================================================= -*-Perl-*-
#
# Template::Plugin::Translit::RU
#
# DESCRIPTION
#   Filter converting cyrillic text into transliterated one.
#
# AUTHOR
#   Igor Lobanov   <igor.lobanov@gmail.com>
#
# COPYRIGHT
#   Copyright (C) 2004 Igor Lobanov.  All Rights Reserved.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
#============================================================================

package Template::Plugin::Translit::RU;
use strict;
use vars qw( $VERSION );
use Template::Plugin;
use base qw( Template::Plugin );

$VERSION = sprintf("%d.%02d", q$Revision: 0.01 $ =~ /(\d+)\.(\d+)/);

# encode table
my $tab = {
	koi	=> {
		single	=> [
			'ÁÂ×ÇÄÅ£ÚÉÊËÌÍÎÏÐÒÓÔÕÆØÙßÜáâ÷çäå³úéêëìíîïðòóôõæøùÿü',
			"abvgdeeziyklmnoprstuf'y'eABVGDEEZIYKLMNOPRSTUF'Y'E"
		],
		plural	=> [
			'(Ö|È|Ã|Þ|Û|Ý|À|Ñ|ö|è|ã|þ|û|ý|à|ñ)',
			{
				'Ö'	=> 'zh',
				'È'	=> 'kh',
				'Ã'	=> 'ts',
				'Þ'	=> 'ch',
				'Û'	=> 'sh',
				'Ý'	=> 'shch',
				'À'	=> 'yu',
				'Ñ'	=> 'ya',
				'ö'	=> 'Zh',
				'è'	=> 'Kh',
				'ã'	=> 'Ts',
				'þ'	=> 'Ch',
				'û'	=> 'Sh',
				'ý'	=> 'Shch',
				'à'	=> 'Yu',
				'ñ'	=> 'Ya'
			}
		]
	},
	win	=> {
		single	=> [
			'àáâãäå¸çèéêëìíîïðñòóôüûúýÀÁÂÃÄÅ¨ÇÈÉÊËÌÍÎÏÐÑÒÓÔÜÛÚÝ',
			"abvgdeeziyklmnoprstuf'y'eABVGDEEZIYKLMNOPRSTUF'Y'E"
		],
		plural	=> [
			'(æ|õ|ö|÷|ø|ù|þ|ÿ|Æ|Õ|Ö|×|Ø|Ù|Þ|ß)',
			{
				'æ'	=> 'zh',
				'õ'	=> 'kh',
				'ö'	=> 'ts',
				'÷'	=> 'ch',
				'ø'	=> 'sh',
				'ù'	=> 'shch',
				'þ'	=> 'yu',
				'ÿ'	=> 'ya',
				'Æ'	=> 'Zh',
				'Õ'	=> 'Kh',
				'Ö'	=> 'Ts',
				'×'	=> 'Ch',
				'Ø'	=> 'Sh',
				'Ù'	=> 'Shch',
				'Þ'	=> 'Yu',
				'ß'	=> 'Ya'
			}
		]
	}
};

# define aliases
$tab->{'windows-1251'} = $tab->{'cp1251'} = $tab->{'win'};
$tab->{'koi8-r'} = $tab->{'koi'};

my $DEFAULT_CHARSET = 'koi';

sub new {
	my ( $class, $context, @params ) = @_;

	# init future object
	my $self = {
		_CONTEXT	=> $context,
		_PARAMS		=> { map { $_ => 1 } @params },
	};

	# check translit flag and define translit filter factory
	if ( $self->{_PARAMS}->{translit} ) {
		$context->define_filter( 'translit', [ \&translit_filter_factory, 1 ] );
	}

	# check detranslit flag and define detranslit filter factory
	if ( $self->{_PARAMS}->{detranslit} ) {
		$context->define_filter( 'detranslit', [ \&detranslit_filter_factory, 1 ] );
	}

	bless $self, $class;
}

sub translit_filter_factory {
    my ( $context, $charset ) = @_;
    return sub {
		my $text = shift;
		Template::Plugin::Translit::RU->translit( $text, $charset );
    }
}

sub detranslit_filter_factory {
    my ( $context, $charset ) = @_;
    return sub {
		my $text = shift;
		Template::Plugin::Translit::RU->detranslit( $text, $charset );
    }
}

sub translit {
	my ( $self, $text, $charset ) = @_;
	$charset ||= $DEFAULT_CHARSET;
	# replace singles
	eval "\$text =~ tr/$tab->{$charset}->{single}->[0]/$tab->{$charset}->{single}->[1]/";
	# replace plurals (most slow place)
	$text =~ s/$tab->{$charset}->{plural}->[0]/$tab->{$charset}->{plural}->[1]->{$1}/sg;
	return $text;
}

sub detranslit {
	my ( $self, $text, $charset ) = @_;
	return '[WARNING: detranslit method not yet supported]';
}

1;

__END__

=pod

=head1 NAME

Template::Plugin::Translit::RU - Filter converting cyrillic
text into transliterated one.

=head1 SYNOPSIS

 [%# Use as filters #%]
 [% USE Translit::RU 'translit' 'detranslit' %]
 [% FILTER translit( 'koi' ) %]
 ...
 This text would stay unchanged because it is not cyrillic.
 ...
 [% END %]

 [%#
    Use as object
    First argument - text for conversion
    Second optional argument - charset ('koi' is default)
 #%]
 [% USE translit = Translit::RU %]
 [% translit.translit( 'without cyrillic text is useless' ) %]
 [% translit.detranslit( 'kirilitsa', 'win' ) %]

=head1 DESCRIPTION

Template::Plugin::Translit::RU is Template Toolkit filter which
allows to convert cyrillic text in one of two popular
charsets koi8-r and windows-1251 into transliterated latin
text.

=head1 SUPPORTED CHARSETS

Currently Template::Plugin::Translit::RU supports 2 main
cyrillic charsets koi8-r and windows-1251.

=head1 IMPORTANT NOTE

This is alpha release of module. Charset tables and other
stuff could be changed in future versions. Method
'detranslit' is not yet implemented. Use this module on your
own risk.

=head1 SEE ALSO

L<Template|Template>

=head1 AUTHOR

Igor Lobanov, E<lt>igor.lobanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (C) 2004 Igor Lobanov. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
