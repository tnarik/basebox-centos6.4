# Description

Use these [Packer](https://packer.io/) templates to generate CentOS 6.4 boxes for different providers.

This set of templates and configuration files is meant to be used with [Packer](https://packer.io/). The latest version tested is `0.8.6`.

# Setup

## Obtain the ISO image

You might prefer to download the CentOS 6.4 ISO previously (or maybe you carry it around in some storage for convenience), but [Packer](https://packer.io/) can obtain the image directly.

You can get the CentOS 6.4 ISO from [http://mirror.nsc.liu.se/centos-store/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso](http://mirror.nsc.liu.se/centos-store/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso)

You can try to use a different version by changing the ISO filename and the checksum referred to in the `template.json` file.

## Provider setup

For most providers, you would need to have the corresponding guest tools already downloaded. To do this, you just need to manually select the creation of a machine from a given ISO and select the installation of the guest tools manually so that they get downloaded locally.

After this is done, you can either abort the instance creation process or delete the instance and use these templates.


# Contents

## Templates

The building process uses a single one with some variables that allow for parameterization:

 * `template.json` : installation of CentOS 6.4.

   ```
   packer build -var 'output_base=/Users/tnarik/Desktop/output' template.json
   ```

### Builders

`virtualbox`, `vmware`, `parallels` are the builder names currently supported.


## Metadata

There is a metadata definition for version local support (without using VagrantCloud/Atlas), based on ERB templates.

The resulting metadata defintions can be used as base, adapting the `url` paths to your working environment.


## Advice

### Speed up development/testing

If you are modifying these images and going through several iterations of testing, it is advisable creating a script that triggers the whole chain of builds and setup.

Typically you would want to select one of the templates building statements and limit the execution to a number of builders via `-only=`, as in:

```
OUTPUT="${HOME}/Desktop/output"
packer build -force -only=virtualbox,vmware -var "output_base=${OUTPUT}" template.json
```

If you want to use version support directly from your filesystem, you can generate the metadata descriptions via: 

```
mkdir -p "${OUTPUT}/centos6.4/"
erb metadata/metadata.json.erb > ${OUTPUT}/centos6.4/metadata.json
```

You can find the `sample_build.sh` script as example on the whole generation chain.


As a result, you would be able to add the boxes to vagrant via the metadata descriptor, selecting the desired provider directly during the import.

```
vagrant box add "${OUTPUT}/centos6.4/metadata.json"
mkdir -p <folder>
cd <folder>
vagrant init tnarik/centos6.4
```

And now you can edit the generated `Vagrantfile` to specify the provider in the descriptor itself to avoid verbose vagrant invocations:

```
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'vmware_fusion'
```

If you don't need or want the version support, you can also add the baseboxes directly from the file system via:

```
vagrant box add --name tnarik/centos6.4 "${OUTPUT}/vagrant/centos6.4-vmware.box" --force
```

### Speed up testing (via Test Kitchen)

In order to generate a box with Chef installed, so that Test Kitchen doesn't attempt downloading/installing Chef everytime, you can use the `generate_with_chef.sh` script to produce a version of the box of your choice with Chef installed.

Just take a look at the script and modify to use the base box you wish. This script relies on the basebox being installed in your system.

## Development

### Versioning

Versioning of the virtual machines takes place via the `metadata.json`. These versions should be linked to git tags, but don't expect to find version `0.0.1` there as this tagging and versioning was introduced after the initial `0.0.1`.

Between versions, the `metadata.json` files could reflect any version number (released version or future version) but should ideally reflect the future one (the one being developed, even if there is no active development on it).

## Caveats
### VMWare

When creating a vagrant box base on the VMware provider, the `pcislotnumber` needs to be forcefully set in the `Vagrantfile` to the same value used by the basebox, via:

```
vb.vmx["ethernet0.pcislotnumber"] = "33"
```

It looks like the Vagrant VMware Fusion Plugin uses a template to recreate the vmx file (or at least in some conditions, or VMWare does this), and this messes up with the interface names, resulting in a non-networked box.  