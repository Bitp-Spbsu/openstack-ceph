sed -i 's|"admin_or_owner":  "is_admin:True or project_id:%(project_id)s",|"admin_or_owner":  "is_admin:True or project_id:%(project_id)s",\n    "admin_or_user":  "is_admin:True or user_id:%(user_id)s",|g' /etc/nova/policy.json
sed -i 's|"default": "rule:admin_or_owner",|"default": "rule:admin_or_user",|g' /etc/nova/policy.json
sed -i 's|"compute:get_all": "",|"compute:get": "rule:admin_or_owner",\n    "compute:get_all": "",|g' /etc/nova/policy.json

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install pyopenssl ndg-httpsclient pyasn1


echo "[filter:voms]

paste.filter_factory = keystone_voms.core:VomsAuthNMiddleware.factory

[pipeline:public_api]

pipeline = sizelimit url_normalize build_auth_context token_auth

admin_token_auth xml_body_v2 json_body ec2_extension voms

user_crud_extension public_service" >> /usr/share/keystone/keystone-dist-paste.ini


