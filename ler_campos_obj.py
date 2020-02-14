import csv
import json
import subprocess

API_VERSION = '47.0'
CONNECTION_NAME = 'vscodeOrg'
OBJECT_NAME = 'SolicitacaoPlano__c'
md = json.loads(subprocess.run(f'sfdx force:schema:sobject:describe -u {CONNECTION_NAME} -s {OBJECT_NAME} --json ',
                               shell=True,
                               capture_output=True).stdout)

campos = []

for campo in md['result']['fields']:
    campo_filtrado = [campo['label'], campo['name'], campo['type'], campo['length'], ','.join(campo['referenceTo']), campo['relationshipName']]
    if 'picklist' in campo['type']:
        campo_filtrado.append(','.join([v['value'] for v in [c for c in campo['picklistValues'] if c['active']]]))

    campos.append(campo_filtrado)


with open('campos.csv', mode='w', encoding='cp1252', newline='') as f:
    f.write('sep=,\n')
    w = csv.writer(f)
    for c in campos:
        w.writerow(c)




