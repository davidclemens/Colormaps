# Colormaps for MATLAB

Multiple colormap sources are unified under one common syntax in this repository to make it easy to use perceptually uniform colormaps in MATLAB. Make sure to read the sources section and the [acknowledgements](./ACKNOWLEDGEMENTS.md), as this repository uses multiple external sources for colormaps.

## Maintain as a git submodule
### Install submodule
1. To add the Colormaps repository as a git submodule run:
```
git submodule add https://github.com/davidclemens/Colormaps.git <relativePathWithinSuperrepository>
```
This should create a `.gitmodules` file in the root of the superrepository, if it doesn't exist yet.
2. In that file add the `branch = release` line. So that it looks like this:
```
[submodule "<relativePathWithinSuperrepository>"]
	path = <relativePathWithinSuperrepository>
	url = https://github.com/davidclemens/Colormaps.git
	branch = release
```

### Update submodule
1. If you want to pull the latest release from this repository to your submodule run
```
git submodule update --remote --merge
```

---
## Sources

### Color Brewer – `cbrewer`

Cynthia A. Brewer's [`colorbrewer v2.0`](https://colorbrewer2.org).

This implementation is based on the raw color palettes published in Scott Lowe's MATLAB implementation [`cbrewer2 v1.0.0.1`](https://www.mathworks.com/matlabcentral/fileexchange/58350-cbrewer2).

### cmocean – `cmocean`

Kristen Thyng's perceptually uniform colormaps for common oceanographic variables [`cmocean`](https://matplotlib.org/cmocean/).

This implementation is based on the raw color palettes published in Chad Greene's MATLAB implementation [`cmocean v2.02`](https://www.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps).

**Reference**
- Thyng, K.M., C.A. Greene, R.D. Hetland, H.M. Zimmerle, and S.F. DiMarco (2016). **True colors of oceanography: Guidelines for effective and accurate colormap selection**. Oceanography 29(3):9–13. [doi:10.5670/oceanog.2016.66](https://doi.org/10.5670/oceanog.2016.66).

### crameri – `crameri`
Fabio Crameri's perceptually uniform [scientific colormaps](https://www.fabiocrameri.ch/colourmaps/).

This implementation is based on the raw color palettes published in Chad Greene's MATLAB implementation [`crameri v1.08`](https://www.mathworks.com/matlabcentral/fileexchange/68546-crameri-perceptually-uniform-scientific-colormaps).

**References**
- Crameri, F. (2018). **Scientific colour maps**. Zenodo. [doi:10.5281/zenodo.1243862](http://doi.org/10.5281/zenodo.1243862)
- Crameri, F. (2018). **Geodynamic diagnostics, scientific visualisation and StagLab 3.0**. Geosci. Model Dev. 11, 2541-2562. [doi:10.5194/gmd-11-2541-2018](https://doi.org/10.5194/gmd-11-2541-2018)
- Crameri, F., G.E. Shephard, and P.J. Heron (2020). **The misuse of colour in science communication**. Nature Communications 11, 5444. [doi:10.1038/s41467-020-19160-7](https://doi.org/10.1038/s41467-020-19160-7)
