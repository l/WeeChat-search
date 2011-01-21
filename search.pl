#
# search.pl is written
# by "AYANOKOUZI, Ryuunosuke" <i38w7i3@yahoo.co.jp>
# under GNU General Public License v3.
#

use strict;
use warnings;
use Data::Dumper;

weechat::register("search", "AYANOKOUZI, Ryuunosuke", "0.1.0", "GPL3", "search buffer", "", "");
weechat::hook_command(
	"search",
	"description", "args", "args_description",
	"connect||disconnect",
	"search",
	"",
);

my $search_buffer = &buffer_open("search_buffer");

sub search
{
	my $data = shift;
	my $buffer = shift;
	my $args =  shift;
	return weechat::WEECHAT_RC_OK if ($args eq '');
	weechat::print($search_buffer, "---\t/search $args");
	my $if = weechat::infolist_get('buffer', '', '');
	while (weechat::infolist_next($if)) {
		my $pointer = weechat::infolist_pointer($if, 'pointer');
		next if $pointer eq $search_buffer;
		my $short_name = weechat::infolist_string($if, 'short_name');

		my $if0 = weechat::infolist_get('buffer_lines', $pointer, '');
		while (weechat::infolist_next($if0)) {
			my $message = weechat::infolist_string($if0, 'message');
			next if $message !~ m/$args/;
			weechat::print($search_buffer, "$short_name\t$message");
		}
		weechat::infolist_free($if0);

	}
	weechat::infolist_free($if);
	return weechat::WEECHAT_RC_OK;
}

sub buffer_open
{
	my $buffer_name = shift;
	my $buffer = weechat::buffer_search('perl', $buffer_name);

	if ($buffer eq '')
	{
		$buffer = weechat::buffer_new($buffer_name, "", "", "", "");
		weechat::print('', "creat buffer named '$buffer_name'");
	}
	weechat::buffer_set($buffer, "title", "$buffer_name");

	return $buffer;
}
