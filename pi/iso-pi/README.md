# pi in the iso sandbox

`atc-box/docker/bin/iso-pi` (`/opt/workspace/config/atc-box`) merges these into the sandbox's `state/iso-pi/settings.json` on every launch
(`iso-merge-config`, in the image):

- `settings.json`: wins on its keys every launch (objects merge key by key, other values are replaced).
- `defaults.json`: fills only keys the file lacks (first run), so `/model` and `pi install` changes survive.

Every other key in the sandbox file is pi's own and is kept. No JSON comments, hence this file.
