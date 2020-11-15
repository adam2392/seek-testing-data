SEEK Testing Dataset
====================

This repository is dedicated to housing a testing dataset of a fake subject used
for testing [`seek`](https://github.com/ncsl/seek/).

Data will be stored as an output of `seek` in the [BIDS format](https://bids-specification.readthedocs.io/).

## Sourcedata
For each subject, there are three folders: `premri/`, `postct/` and `postmri/` containing
test subject dicom files. 

For a description of these, please refer to https://github.com/ncsl/seek/workflow/documentation.md

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
