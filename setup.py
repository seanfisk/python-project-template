from pathlib import Path
import setuptools

project_dir = Path(__file__).parent

with open('README.md', 'r') as fh:
    long_description = fh.read()

setuptools.setup(
    name='app_name',
    version='0.1.0',
    description='app_description',
    long_description=long_description,
    long_description_content_type='text/markdown',
    keywords=['python'],
    author='first_name last_name',
    url='url_to_git_repo',
    packages=setuptools.find_packages('src'),
    package_dir={'': 'src'},
    python_requires='>=3.6',
    include_package_data=True,
    install_requires=(project_dir / 'requirements.txt').read_text().split('\n'),
    zip_safe=False,
    license='license_type',
    license_files=['LICENSE'],
    classifiers=[
        'Development Status :: 1 - Planning',
    ]
)
