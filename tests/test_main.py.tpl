import pytest
from mock import patch, call

from $package import metadata
from ${package}.main import _main


@pytest.fixture(params=['-h', '--help'])
def helparg(request):
    return request.param


@pytest.fixture(params=['-v', '--version'])
def versionarg(request):
    return request.param


class TestMain(object):
    def test_help(self, helparg, capsys):
        with patch('sys.exit', autospec=True, spec_set=True) as mock_exit:
            mock_exit.side_effect = Exception(
                'fake exception to stop execution')
            with pytest.raises(Exception):
                _main(['progname', helparg])
        out, err = capsys.readouterr()
        # Should have printed some sort of usage message. We don't
        # need to explicitly test the content of the message.
        assert 'usage' in out
        # Should have used the program name from the argument
        # vector.
        assert 'progname' in out
        # Should exit with zero return code.
        assert mock_exit.mock_calls == [call(0)]

    def test_version(self, versionarg, capsys):
        with patch('sys.exit', autospec=True, spec_set=True) as mock_exit:
            mock_exit.side_effect = Exception(
                'fake exception to stop execution')
            with pytest.raises(Exception):
                _main(['progname', versionarg])
        out, err = capsys.readouterr()
        assert err == '{0} {1}\n'.format(metadata.project, metadata.version)
