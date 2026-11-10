import zipfile
import xml.etree.ElementTree as ET
import json
import os
from datetime import datetime, timedelta

def clean_str(val):
    if val is None:
        return ''
    return str(val).strip()

def safe_float(val, default=None):
    if val is None or val == '':
        return default
    try:
        clean = str(val).replace('%', '').strip()
        parts = clean.split()
        if parts:
            return float(parts[0])
        return float(clean)
    except Exception:
        return default

def excel_date_to_str(serial):
    if not serial:
        return None
    try:
        val = float(serial)
        if val < 1000:
            return str(serial)
        dt = datetime(1899, 12, 30) + timedelta(days=val)
        return dt.strftime('%Y-%m-%d')
    except Exception:
        return str(serial)

def parse_xlsx_sheets(xlsx_path):
    with zipfile.ZipFile(xlsx_path) as z:
        shared_strings = []
        if 'xl/sharedStrings.xml' in z.namelist():
            ss_root = ET.fromstring(z.read('xl/sharedStrings.xml'))
            for si in ss_root.findall('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}si'):
                text = ''.join(t.text for t in si.findall('.//{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t') if t.text)
                shared_strings.append(text)
        
        rels_root = ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
        rel_map = {rel.attrib['Id']: rel.attrib['Target'] for rel in rels_root.findall('{http://schemas.openxmlformats.org/package/2006/relationships}Relationship')}
        wb_root = ET.fromstring(z.read('xl/workbook.xml'))
        ns = {'main': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
        
        result = {}
        for sheet in wb_root.findall('.//main:sheet', ns):
            name = sheet.attrib.get('name')
            r_id = sheet.attrib.get('{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id')
            target = 'xl/' + rel_map[r_id]
            
            sheet_root = ET.fromstring(z.read(target))
            rows_data = []
            for row in sheet_root.findall('.//main:row', ns):
                r_num = int(row.attrib.get('r'))
                row_dict = {}
                for cell in row.findall('.//main:c', ns):
                    c_ref = cell.attrib.get('r')
                    c_type = cell.attrib.get('t')
                    v_el = cell.find('main:v', ns)
                    val = v_el.text if v_el is not None else ''
                    if c_type == 's' and val.isdigit():
                        val = shared_strings[int(val)]
                    col_letters = ''.join([c for c in c_ref if c.isalpha()])
                    row_dict[col_letters] = val
                if any(row_dict.values()):
                    rows_data.append((r_num, row_dict))
            result[name] = rows_data
        return result

print("Reading herramienta_sga.xlsx...")
data = parse_xlsx_sheets('herramienta_sga.xlsx')
print("Sheets parsed:", list(data.keys()))

# 1. Parse Catálogo Cod. SUDEBIP
sudebip_items = []
for r_num, row in data.get('Catálogo Cod. SUDEBIP', []):
    if r_num <= 1:
        continue
    cod = clean_str(row.get('C'))
    tipo = clean_str(row.get('D'))
    if cod and tipo:
        sudebip_items.append({'codigo': cod, 'tipo_equipo': tipo})

print(f"Parsed {len(sudebip_items)} SUDEBIP catalog items.")

# 2. Parse Jerarquización (Sheet 2)
# Row 10 is header, rows > 10 are data
jer_map = {}
for r_num, row in data.get('2. Jerarquización ', []):
    if r_num <= 10:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    jer_map[tag] = {
        'tag_pdvsa': tag,
        'nombre': clean_str(row.get('C')),
        'laboratorio': clean_str(row.get('D')),
        'ff': safe_float(row.get('E')),
        'io': safe_float(row.get('F')),
        'fo': safe_float(row.get('G')),
        'cm': safe_float(row.get('H')),
        'sha': safe_float(row.get('I')),
        'consecuencia': safe_float(row.get('J')),
        'ic': safe_float(row.get('K')),
        'categoria_criticidad': clean_str(row.get('L')),
        'estatus_seleccion': clean_str(row.get('M')),
        'criterio_accion': clean_str(row.get('N')),
    }

print(f"Parsed {len(jer_map)} Jerarquización evaluations.")

# 3. Parse Obsolescencia (Sheet 3)
obs_map = {}
for r_num, row in data.get('3. Índice Obsolescencia Iobs', []):
    if r_num <= 9:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    iobs_raw = safe_float(row.get('J'))
    obs_map[tag] = {
        'tag_pdvsa': tag,
        'nombre': clean_str(row.get('C')),
        'laboratorio': clean_str(row.get('D')),
        'eol': safe_float(row.get('E')),
        'rep': safe_float(row.get('F')),
        'met': safe_float(row.get('G')),
        'ant': safe_float(row.get('H')),
        'suma_puntos': safe_float(row.get('I')),
        'iobs': round(iobs_raw, 2) if iobs_raw is not None else None,
        'estatus_obsolescencia': clean_str(row.get('K')),
    }

print(f"Parsed {len(obs_map)} Obsolescencia evaluations.")

# 4. Parse Riesgos y Oportunidades (Sheet 4)
riesgo_map = {}
for r_num, row in data.get('4. Evaluación Riesgos y Oport.', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    riesgo_map[tag] = {
        'tag_pdvsa': tag,
        'categoria_aca': clean_str(row.get('E')),
        'iobs': safe_float(row.get('F')),
        'nivel_riesgo': safe_float(row.get('S')),
        'clasificacion_riesgo': clean_str(row.get('T')),
        'beneficio': safe_float(row.get('V')),
        'viabilidad': safe_float(row.get('W')),
        'nivel_oportunidad': safe_float(row.get('X')),
        'prioridad_oportunidad': clean_str(row.get('Y')),
        'decision_sugerida': clean_str(row.get('Z')),
    }

print(f"Parsed {len(riesgo_map)} Riesgos evaluations.")

# 5. Parse Matriz Cruce (Sheet 5)
cruce_map = {}
for r_num, row in data.get('5. Matriz Cruce Iobs vs Riesgo', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    cruce_map[tag] = {
        'tag_pdvsa': tag,
        'nivel_riesgo': safe_float(row.get('E')),
        'iobs': safe_float(row.get('F')),
        'resultado_cruce': clean_str(row.get('G')),
        'decision_sugerida': clean_str(row.get('H')),
    }

print(f"Parsed {len(cruce_map)} Matriz Cruce evaluations.")

# 6. Parse Consolidación de Decisiones (Sheet 6)
dec_map = {}
for r_num, row in data.get('6. Consolidación de Decisiones', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    dec_map[tag] = {
        'tag_pdvsa': tag,
        'resultado_cruce': clean_str(row.get('G')),
        'decision_sugerida_riesgo': clean_str(row.get('H')),
        'prioridad_oportunidad': clean_str(row.get('J')),
        'decision_sugerida_oportunidad': clean_str(row.get('K')),
        'decision_estrategica_final': clean_str(row.get('L')),
        'responsable_de': clean_str(row.get('M')),
        'fecha_de': excel_date_to_str(row.get('N', '')),
        'decision_operativa': clean_str(row.get('O')),
        'responsable_do': clean_str(row.get('P')),
        'fecha_do': excel_date_to_str(row.get('Q', '')),
    }

print(f"Parsed {len(dec_map)} Decisiones.")

# 7. Parse Master Inventory (Sheet 1)
activos_list = []
for r_num, row in data.get('1. Inventario y Pareto 20%', []):
    if r_num <= 8:
        continue
    tag = clean_str(row.get('B'))
    if not tag:
        continue
    
    pareto_str = clean_str(row.get('O')).lower()
    is_pareto = (pareto_str in ['sí', 'si', 'yes', 'true'])
    
    num_val = None
    try:
        num_val = int(float(row.get('A', 0)))
    except Exception:
        num_val = len(activos_list) + 1

    # Merge evaluations
    j_data = jer_map.get(tag, {})
    o_data = obs_map.get(tag, {})
    r_data = riesgo_map.get(tag, {})
    c_data = cruce_map.get(tag, {})
    d_data = dec_map.get(tag, {})

    cat_crit = j_data.get('categoria_criticidad') or clean_str(row.get('M')) or 'No Evaluado'
    iobs_val = o_data.get('iobs')
    est_obs = o_data.get('estatus_obsolescencia')
    nr_val = r_data.get('nivel_riesgo') if r_data.get('nivel_riesgo') is not None else c_data.get('nivel_riesgo')
    res_cruce = d_data.get('resultado_cruce') or c_data.get('resultado_cruce')
    
    decision_obj = None
    if d_data:
        decision_obj = {
            'cruce_resultado': res_cruce,
            'decision_sugerida_riesgo': d_data.get('decision_sugerida_riesgo'),
            'prioridad_oportunidad': d_data.get('prioridad_oportunidad'),
            'decision_sugerida_oportunidad': d_data.get('decision_sugerida_oportunidad'),
            'decision_estrategica_final': d_data.get('decision_estrategica_final'),
            'responsable_de': d_data.get('responsable_de'),
            'fecha_de': d_data.get('fecha_de'),
            'decision_operativa': d_data.get('decision_operativa'),
            'responsable_do': d_data.get('responsable_do'),
            'fecha_do': d_data.get('fecha_do'),
        }

    activo = {
        'num': num_val,
        'tag_pdvsa': tag,
        'codigo_sudebip': clean_str(row.get('C')) or 'Sin Código',
        'codigo_sap': clean_str(row.get('D')) or 'Sin Información',
        'nombre': clean_str(row.get('E')),
        'marca': clean_str(row.get('I')) or 'Sin Información',
        'modelo': clean_str(row.get('J')) or 'Sin Información',
        'serial': clean_str(row.get('K')) or 'Sin Información',
        'laboratorio': clean_str(row.get('L')) or 'Gerencia de Ambiente',
        'criticidad_analista': clean_str(row.get('M')),
        'tipo_equipo': clean_str(row.get('N')),
        'pareto_20': is_pareto,
        'estado_operativo': 'Operativo',
        'filial': 'PDVSA INTEVEP S.A.',
        'sede': 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'gerencia': 'Gerencia de Ambiente',
        'categoria_criticidad': cat_crit,
        'ic': j_data.get('ic'),
        'iobs': iobs_val,
        'estatus_obsolescencia': est_obs,
        'nivel_riesgo': nr_val,
        'clasificacion_riesgo': r_data.get('clasificacion_riesgo'),
        'nivel_oportunidad': r_data.get('nivel_oportunidad'),
        'prioridad_oportunidad': r_data.get('prioridad_oportunidad'),
        'resultado_cruce': res_cruce,
        'jerarquizacion': j_data if j_data else None,
        'obsolescencia': o_data if o_data else None,
        'decision': decision_obj
    }
    activos_list.append(activo)

print(f"Total activos compiled: {len(activos_list)}")
pareto_count = len([a for a in activos_list if a['pareto_20']])
print(f"Total Pareto 20%: {pareto_count}")
crit_a = len([a for a in activos_list if 'Nivel A' in (a.get('categoria_criticidad') or '')])
print(f"Criticos Nivel A: {crit_a}")
crit_b = len([a for a in activos_list if 'Nivel B' in (a.get('categoria_criticidad') or '')])
print(f"Criticos Nivel B: {crit_b}")
crit_c = len([a for a in activos_list if 'Nivel C' in (a.get('categoria_criticidad') or '')])
print(f"Criticos Nivel C: {crit_c}")
