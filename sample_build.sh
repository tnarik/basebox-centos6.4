OUTPUT="${HOME}/Desktop/output"
packer build -force -only=virtualbox,vmware -var "output_base=${OUTPUT}" template.json
packer build -force -only=parallels -var "output_base=${OUTPUT}" template.json

mkdir -p ${OUTPUT}/centos6.4/.
erb metadata/metadata.json.erb > ${OUTPUT}/centos6.4/metadata.json
