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

$VERSION = sprintf("%d.%02d", q$Revision: 0.04 $ =~ /(\d+)\.(\d+)/);

# (en|de)code table
my $tab = {
	koi	=> {
		# {1} => {1}
		single	=> [
			'ÁÂ×ÇÄÅÚÉÊËÌÍÎÏÐÒÓÔÕÆØßáâ÷çäåúéêëìíîïðòóôõæøÿ',
			"abvgdezijklmnoprstuf'\"ABVGDEZIJKLMNOPRSTUF'\""
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(Ø[Å£ÀÑ]|£|Ö|È|Ã|Þ|Û|Ý|Ù|Ü|À|Ñ|ø[å³àñ]|³|ö|è|ã|þ|û|ý|ù|ü|à|ñ)',
			# 1: table for these letters and cases [0]
			{
				'£'		=> 'yo',
				'³'		=> 'Yo',
				'Ö'		=> 'zh',
				'ö'		=> 'Zh',
				'È'		=> 'kh',
				'è'		=> 'Kh',
				'Ã'		=> 'tc',
				'ã'		=> 'Tc',
				'Þ'		=> 'ch',
				'þ'		=> 'Ch',
				'Û'		=> 'sh',
				'û'		=> 'Sh',
				'Ý'		=> 'shch',
				'ý'		=> 'Shch',
				'Ù'		=> 'yi',
				'ù'		=> 'Yi',
				'Ü'		=> 'ye',
				'ü'		=> 'Ye',
				'À'		=> 'yu',
				'à'		=> 'Yu',
				'Ñ'		=> 'ya',
				'ñ'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'ØÅ'	=> 'jie',
				'øå'	=> 'JIE',
				'Ø£'	=> 'jio',
				'ø³'	=> 'JIO',
				'ØÀ'	=> 'jiu',
				'øà'	=> 'JIU',
				'ØÑ'	=> 'jia',
				'øñ'	=> 'JIA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|ji[eoua]|JI[EOUA]|yo|zh|kh|tc|ch|sh|yi|ye|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Ii]|Y[Ee]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> 'Ý',
				'SHCH'	=> 'ý',
				'Shch'	=> 'ý',
				'tch'	=> 'ÔÞ',
				'TCH'	=> 'ôþ',
				'Tch'	=> 'ôÞ',
				'jie'	=> 'ØÅ',
				'jio'	=> 'Ø£',
				'jiu'	=> 'ØÀ',
				'jia'	=> 'ØÑ',
				'JIE'	=> 'øå',
				'JIO'	=> 'ø³',
				'JIU'	=> 'øà',
				'JIA'	=> 'øñ',
				'yo'	=> '£',
				'zh'	=> 'Ö',
				'kh'	=> 'È',
				'tc'	=> 'Ã',
				'ch'	=> 'Þ',
				'sh'	=> 'Û',
				'yi'	=> 'Ù',
				'ye'	=> 'Ü',
				'yu'	=> 'À',
				'ya'	=> 'Ñ',
				'YO'	=> '³',
				'Yo'	=> '³',
				'ZH'	=> 'ö',
				'Zh'	=> 'ö',
				'KH'	=> 'è',
				'Kh'	=> 'è',
				'TC'	=> 'ã',
				'Tc'	=> 'ã',
				'CH'	=> 'þ',
				'Ch'	=> 'þ',
				'SH'	=> 'û',
				'Sh'	=> 'û',
				'YI'	=> 'ù',
				'Yi'	=> 'ù',
				'YE'	=> 'ü',
				'Ye'	=> 'ü',
				'YU'	=> 'à',
				'Yu'	=> 'à',
				'YA'	=> 'ñ',
				'Ya'	=> 'ñ',
			}
		]
	},
	win	=> {
		# {1} => {1}
		single	=> [
			'àáâãäåçèéêëìíîïðñòóôüúÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÜÚ',
			"abvgdezijklmnoprstuf'\"ABVGDEZIJKLMNOPRSTUF'\""
		],
		# +	=> {2,}
		plural	=> [
			# 0: re with plural-transliterated letters and special cases
			'(ü[å¸þÿ]|¸|æ|õ|ö|÷|ø|ù|û|ý|þ|ÿ|Ü[Å¨Þß]|¨|Æ|Õ|Ö|×|Ø|Ù|Û|Ý|Þ|ß)',
			# 1: table for these letters and cases [0]
			{
				'¸'		=> 'yo',
				'¨'		=> 'Yo',
				'æ'		=> 'zh',
				'Æ'		=> 'Zh',
				'õ'		=> 'kh',
				'Õ'		=> 'Kh',
				'ö'		=> 'tc',
				'Ö'		=> 'Tc',
				'÷'		=> 'ch',
				'×'		=> 'Ch',
				'ø'		=> 'sh',
				'Ø'		=> 'Sh',
				'ù'		=> 'shch',
				'Ù'		=> 'Shch',
				'û'		=> 'yi',
				'Û'		=> 'Yi',
				'ý'		=> 'ye',
				'Ý'		=> 'Ye',
				'þ'		=> 'yu',
				'Þ'		=> 'Yu',
				'ÿ'		=> 'ya',
				'ß'		=> 'Ya',
				# {2} => {2,3} - could not be at the begining of the word
				'üå'	=> 'jie',
				'ÜÅ'	=> 'JIE',
				'ü¸'	=> 'jio',
				'Ü¨'	=> 'JIO',
				'üþ'	=> 'jiu',
				'ÜÞ'	=> 'JIU',
				'üÿ'	=> 'jia',
				'Üß'	=> 'JIA',
			},
			# 3: re with special transliterated escapes
			'(shch|Shch|SHCH|tch|TCH|Tch|ji[eoua]|JI[EOUA]|yo|zh|kh|tc|ch|sh|yi|ye|yu|ya|Y[Oo]|Z[Hh]|K[Hh]|T[Cc]|C[Hh]|S[Hh]|Y[Ii]|Y[Ee]|Y[Uu]|Y[Aa])',
			# 4: table for special transliterated escapes [3]
			{
				'shch'	=> 'ù',
				'SHCH'	=> 'Ù',
				'Shch'	=> 'Ù',
				'tch'	=> 'ò÷',
				'TCH'	=> 'Ò×',
				'Tch'	=> 'Ò÷',
				'jie'	=> 'üå',
				'jio'	=> 'ü¸',
				'jiu'	=> 'üþ',
				'jia'	=> 'üÿ',
				'JIE'	=> 'ÜÅ',
				'JIO'	=> 'Ü¨',
				'JIU'	=> 'ÜÞ',
				'JIA'	=> 'Üß',
				'yo'	=> '¸',
				'zh'	=> 'æ',
				'kh'	=> 'õ',
				'tc'	=> 'ö',
				'ch'	=> '÷',
				'sh'	=> 'ø',
				'yi'	=> 'û',
				'ye'	=> 'ý',
				'yu'	=> 'þ',
				'ya'	=> 'ÿ',
				'YO'	=> '¨',
				'Yo'	=> '¨',
				'ZH'	=> 'Æ',
				'Zh'	=> 'Æ',
				'KH'	=> 'Õ',
				'Kh'	=> 'Õ',
				'TC'	=> 'Ö',
				'Tc'	=> 'Ö',
				'CH'	=> '×',
				'Ch'	=> '×',
				'SH'	=> 'Ø',
				'Sh'	=> 'Ø',
				'YI'	=> 'Û',
				'Yi'	=> 'Û',
				'YE'	=> 'Ý',
				'Ye'	=> 'Ý',
				'YU'	=> 'Þ',
				'Yu'	=> 'Þ',
				'YA'	=> 'ß',
				'Ya'	=> 'ß',
			}
		]
	}
};

# define aliases
$tab->{'windows-1251'} = $tab->{'cp1251'} = $tab->{'win'};
$tab->{'koi8-r'} = $tab->{'koi8r'} = $tab->{'koi8'} = $tab->{'koi'};

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
	# replace plurals (most slow place)
	$text =~ s/$tab->{$charset}->{plural}->[0]/$tab->{$charset}->{plural}->[1]->{$1}/sg;
	# replace singles
	eval "\$text =~ tr/$tab->{$charset}->{single}->[0]/$tab->{$charset}->{single}->[1]/";
	return $text;
}

sub detranslit {
	my ( $self, $text, $charset ) = @_;
	$charset ||= $DEFAULT_CHARSET;
	# replace plurals (most slow place)
	$text =~ s/$tab->{$charset}->{plural}->[2]/$tab->{$charset}->{plural}->[3]->{$1}/sge;
	# replace singles
	eval "\$text =~ tr/$tab->{$charset}->{single}->[1]/$tab->{$charset}->{single}->[0]/";
	return $text;
}

1;

__END__

=pod

=head1 NAME

Template::Plugin::Translit::RU - Filter converting cyrillic
text into transliterated one and back.

=head1 SYNOPSIS

Use as filters.

 [% USE Translit::RU 'translit' 'detranslit' %]
 [% FILTER translit( 'koi' ) %]
 ...
 This text would stay unchanged because it is not cyrillic.
 ...
 [% END %]

Use as object. First argument - text for conversion. Second
optional argument - charset ('koi' is default).

 [% USE plTranslit = Translit::RU %]
 [% plTranslit.translit( 'without cyrillic text is useless' ) %]
 [% plTranslit.detranslit( 'kirilitca', 'win' ) %]

=head1 DESCRIPTION

Template::Plugin::Translit::RU is Template Toolkit filter
which allows to convert cyrillic text into transliterated
latin text. Currently two most popular charsets are
supported - B<koi8-r> and B<windows-1251>. Also back
conversion supported.

=head1 SUPPORTED CHARSETS

Currently Template::Plugin::Translit::RU supports 2 main
cyrillic charsets B<koi8-r> and B<windows-1251>.

Charset arguments could take such values:

=over

=item * 'koi', 'koi8-r', 'koi8r', 'koi8' - for B<koi8-r>
charset.

=item * 'win', 'windows-1251', 'cp1251' - for
B<windows-1251> charset.

=back

=head1 KNOWN PROBLEMS

In some cases there is no exact correspondence between
source cyrillic word and result of
B<cyrillic>->B<translit>->B<cyrillic> conversion
(B<CTC>-conversion). Although one of the aims of this module
is to find such correspondence, this is difficult without
making transliterated text bad understandable. Currently 2
main problems are known:

=over

=item * Case loss while conversion of hard and soft signs
(UPPER source after B<CTC> become lower). This could take
place if you make B<CTC>-conversion with UPPER case words.
Fortunately there are no words which starts with signs.

=item * Wrong B<CTC>-conversion in rare cases where cyrillic
letters 'B<sh>' and 'B<ch>' meets one after another. In this
case they are converted in cyrillic letter 'B<shch>'. This
is rare case (I met it only twice after scaning dictionary
with 130000 words) and very rare words.

=back

=head1 IMPORTANT NOTE

This is alpha release of module. Charset tables and other
stuff could be changed in future versions. Use this module
on your own risk.

=head1 SEE ALSO

L<Template|Template>

=head1 AUTHOR

Igor Lobanov, E<lt>igor.lobanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (C) 2004 Igor Lobanov. All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
