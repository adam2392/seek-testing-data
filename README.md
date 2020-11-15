SEEK Testing Dataset
====================

This repository is dedicated to housing a testing dataset of a fake subject used
for testing [`seek`](https://github.com/ncsl/seek/).

Data will be stored as an output of `seek` in the [BIDS format](https://bids-specification.readthedocs.io/).

## Sourcedata
For each subject, there was a raw EDF file, which was converted into the BrainVision format with `mne_bids`. Each subject with SEEG implantation, also has an Excel table, called `electrode_layout.xlsx`, which outlines where the clinicians marked each electrode anatomically. Note that there is no rigorous atlas applied, so the main points of interest are: `WM`, `GM`, `VENTRICLE`, `CSF`, and `OUT`, which represent white-matter, gray-matter, ventricle, cerebrospinal fluid and outside the brain. WM, Ventricle, CSF and OUT were removed channels from further analysis. These were labeled in the corresponding BIDS `channels.tsv` sidecar file as `status=bad`.

## Derivatives
Derivatives include the `freesurfer/` output, which corresponds to the
`SUBJECTS_DIR` environment variable in FreeSurfer. Inside this directory, it would be
organized as:

    freesurfer/
        <subject_id>/
            mri/
            acpc/
            elecs/
            ct/
            ...

Add or change files in the repo for use with SEEK
-------------------------------------------------
1. Ensure your only option is to add files here. Alternatives would be e.g.:

   - See if you can make use of existing files
   - Synthesize the necessary testing files using e.g. NumPy, Nibabel directly

2. If new files are needed, make a PR to this repo to add your files.

   .. warning:: Make files as small as possible while ensuring proper testing!
                This often means e.g. downsampling to a very low resolution data.

3. Update the `Version` in `dataset_description.json` of the repo in your PR to the next increment.

4. Once your PR is merged, ask a maintainer to cut a new release of the testing data, e.g. 0.53.

5. In SEEK, update testing data to use latest version.
