import zipfile
import xml.etree.ElementTree as ET
import json
import os
from datetime import datetime, timedelta

def safe_float(val, default=0.0):
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
                rows_data.append((r_num, row_dict))
            result[name] = rows_data
        return result

print('Parsing Excel files...')
hv_data = parse_xlsx_sheets('./hoja_de_vida_integral.xlsx')
anexos_data = parse_xlsx_sheets('./formularios_anexos_sga.xlsx')

# Load base 334 assets
with open('sga_data.json', 'r', encoding='utf-8') as f:
    base_sga = json.load(f)

activos_map = {a['tag_pdvsa']: a for a in base_sga.get('activos', [])}

# 1. Parse INVENTARIO_GENERAL from hoja_de_vida_integral
inv_rows = hv_data.get('INVENTARIO_GENERAL', [])
# Row 4 is header
col_map = inv_rows[2][1] if len(inv_rows) > 2 else {}
detailed_assets = []
for r_num, row in inv_rows:
    if r_num < 5:
        continue
    tag = row.get('A', '').strip()
    if not tag:
        continue
    
    asset_detail = {
        'tag_pdvsa': tag,
        'nombre': row.get('B', '').strip(),
        'fabricante': row.get('C', '').strip(),
        'modelo': row.get('D', '').strip(),
        'serial': row.get('E', '').strip(),
        'filial': row.get('F', '').strip(),
        'sede': row.get('G', '').strip(),
        'gerencia': row.get('H', '').strip(),
        'laboratorio': row.get('I', '').strip(),
        'sistema': row.get('J', '').strip(),
        'custodio': row.get('K', '').strip(),
        'categoria_criticidad': row.get('L', '').strip(),
        'estado_operativo': row.get('M', '').strip(),
        'etapa_ciclo_vida': row.get('N', '').strip(),
        'fecha_puesta_servicio': excel_date_to_str(row.get('O')),
        'codigo_sudebip': row.get('P', '').strip(),
        'numero_etiqueta_qr': row.get('Q', '').strip(),
        'condicion_fisica': row.get('R', '').strip(),
        'costo_adquisicion_usd': float(row.get('S', 0) or 0),
        'clasificacion_sudebip': row.get('T', '').strip(),
        'unidad_administradora': row.get('U', '').strip(),
        'responsable_patrimonial': row.get('V', '').strip(),
        'nro_orden_compra': row.get('W', '').strip(),
        'responsable_custodia': row.get('X', '').strip(),
        'estatus_sigebi': row.get('Y', '').strip(),
        'rango_medicion': row.get('Z', '').strip(),
        'rango_temperatura': row.get('AA', '').strip(),
        'limite_deteccion': row.get('AB', '').strip(),
        'mep': row.get('AC', '').strip(),
        'software_version': row.get('AD', '').strip(),
        'condiciones_ambientales': row.get('AE', '').strip(),
        'suministro_electrico': row.get('AF', '').strip(),
        'precinto_seguridad': row.get('AG', '').strip(),
        'frecuencia_calibracion': row.get('AH', '').strip(),
        'frecuencia_comprobacion': row.get('AI', '').strip(),
        'riesgos_fisicos': row.get('AJ', '').strip(),
        'epp_operacion': row.get('AK', '').strip(),
        'riesgos_quimicos': row.get('AL', '').strip(),
        'epp_mantenimiento': row.get('AM', '').strip(),
        'riesgos_termicos': row.get('AN', '').strip(),
        'procedimiento_loto': row.get('AO', '').strip(),
        'dispositivos_seguridad': row.get('AP', '').strip(),
        'ubicacion_emergencia': row.get('AQ', '').strip(),
        'estrategia_mantenimiento': row.get('AR', '').strip(),
        'frecuencia_mantenimiento': row.get('AS', '').strip(),
        'codigo_plan_pdvsa': row.get('AT', '').strip(),
        'proveedor_tecnico': row.get('AU', '').strip(),
        'vida_util_anos': float(row.get('AV', 10) or 10),
        'tasa_salvamento': float(row.get('AW', 0.1) or 0.1)
    }
    detailed_assets.append(asset_detail)
    # Merge into base assets map or create new
    if tag in activos_map:
        activos_map[tag].update(asset_detail)
    else:
        activos_map[tag] = asset_detail

print(f'Processed {len(detailed_assets)} deep-profile assets.')

# 2. Parse Calibraciones Metrológicas
cal_rows = hv_data.get('HISTORIAL_CALIBRACION_METROLOGI', [])
calibraciones = []
for r_num, row in cal_rows:
    if r_num < 5:
        continue
    tag = row.get('A', '').strip()
    id_cal = row.get('B', '').strip()
    if not tag or not id_cal:
        continue
    cal = {
        'id_calibracion': id_cal,
        'tag_pdvsa': tag,
        'nro_certificado': row.get('C', '').strip(),
        'fecha_calibracion': excel_date_to_str(row.get('D')),
        'fecha_vencimiento': excel_date_to_str(row.get('E')),
        'dias_restantes': int(float(row.get('F', 0) or 0)),
        'estatus_metrologico': row.get('G', '').strip(),
        'entidad_acreditada': row.get('H', '').strip(),
        'patron_utilizado': row.get('I', '').strip(),
        'desviacion_observada': row.get('J', '').strip(),
        'incertidumbre_u': row.get('K', '').strip(),
        'mep_tolerancia': row.get('L', '').strip(),
        'dictamen': row.get('M', '').strip(),
        'precinto_colocado': row.get('N', '').strip(),
        'metrologo_responsable': row.get('O', '').strip(),
        'observaciones': row.get('P', '').strip()
    }
    calibraciones.append(cal)

print(f'Processed {len(calibraciones)} calibration logs.')

# 3. Parse Mantenimientos PDVSA
mant_rows = hv_data.get('REGISTRO_MANTENIMIENTO_PDVSA', [])
mantenimientos = []
for r_num, row in mant_rows:
    if r_num < 5:
        continue
    tag = row.get('A', '').strip()
    nro_ot = row.get('B', '').strip()
    if not tag or not nro_ot:
        continue
    ot = {
        'nro_ot': nro_ot,
        'tag_pdvsa': tag,
        'tipo_mantenimiento': row.get('C', '').strip(),
        'codigo_plan_pdvsa': row.get('D', '').strip(),
        'fecha_inicio': excel_date_to_str(row.get('E')),
        'fecha_cierre': excel_date_to_str(row.get('F')),
        'descripcion': row.get('G', '').strip(),
        'repuestos_reemplazados': row.get('H', '').strip(),
        'horas_hombre': float(row.get('I', 0) or 0),
        'costo_total_usd': float(row.get('J', 0) or 0),
        'responsable_ejecucion': row.get('K', '').strip(),
        'impacto_ensayos_iso17025': row.get('L', '').strip(),
        'requiere_recalibracion': 'Sí' in row.get('M', '') or 'SI' in row.get('M', '').upper(),
        'estatus_ot': row.get('N', '').strip(),
        'aprobado_por': row.get('O', '').strip(),
        'proximo_mantenimiento': excel_date_to_str(row.get('P'))
    }
    mantenimientos.append(ot)

print(f'Processed {len(mantenimientos)} maintenance work orders.')

# 4. Parse Comprobaciones Intermedias
ci_rows = hv_data.get('COMPROBACIONES_INTERMEDIAS', [])
comprobaciones = []
for r_num, row in ci_rows:
    if r_num < 5:
        continue
    tag = row.get('A', '').strip()
    id_ci = row.get('B', '').strip()
    if not tag or not id_ci:
        continue
    ci = {
        'id_comprobacion': id_ci,
        'tag_pdvsa': tag,
        'fecha_verificacion': excel_date_to_str(row.get('C')),
        'parametro_verificado': row.get('D', '').strip(),
        'patron_referencia': row.get('E', '').strip(),
        'limite_min': float(row.get('F', 0) or 0),
        'limite_max': float(row.get('G', 0) or 0),
        'valor_experimental': float(row.get('H', 0) or 0),
        'dictamen_auto': row.get('I', '').strip(),
        'desviacion_observada': row.get('J', '').strip(),
        'rotulado_operativo': row.get('K', '').strip(),
        'analista_responsable': row.get('L', '').strip(),
        'observaciones': row.get('M', '').strip()
    }
    comprobaciones.append(ci)

print(f'Processed {len(comprobaciones)} intermediate checks.')

# 5. Parse Control Patrimonial SUDEBIP (Depreciación y Movimientos)
patr_rows = hv_data.get('CONTROL_PATRIMONIAL_SUDEBIP', [])
depreciaciones = []
movimientos = []
mode = 'deprec'
for r_num, row in patr_rows:
    if 'TABLA 5B' in str(row.get('A', '')):
        mode = 'mov'
        continue
    tag = row.get('A', '').strip()
    if not tag or tag.startswith('Tag') or tag.startswith('TABLA'):
        continue
    
    if mode == 'deprec':
        d = {
            'tag_pdvsa': tag,
            'codigo_sigebi': row.get('B', '').strip(),
            'denominacion': row.get('C', '').strip(),
            'fecha_incorporacion': excel_date_to_str(row.get('D')),
            'costo_adquisicion_usd': float(row.get('E', 0) or 0),
            'tasa_salvamento': float(row.get('F', 0) or 0),
            'valor_residual_salvamento': float(row.get('G', 0) or 0),
            'base_depreciable_usd': float(row.get('H', 0) or 0),
            'vida_util_anos': float(row.get('I', 0) or 0),
            'meses_uso': int(float(row.get('J', 0) or 0)),
            'depreciacion_mensual_usd': float(row.get('K', 0) or 0),
            'depreciacion_acumulada_usd': float(row.get('L', 0) or 0),
            'valor_neto_libros_usd': float(row.get('M', 0) or 0)
        }
        depreciaciones.append(d)
    else:
        m = {
            'tag_pdvsa': tag,
            'nro_acta': row.get('B', '').strip(),
            'fecha_movimiento': excel_date_to_str(row.get('C')),
            'tipo_movimiento': row.get('D', '').strip(),
            'unidad_emisora': row.get('E', '').strip(),
            'unidad_receptora': row.get('F', '').strip(),
            'responsable_entrega': row.get('G', '').strip(),
            'responsable_receptor': row.get('H', '').strip(),
            'nro_autorizacion': row.get('I', '').strip(),
            'condicion_fisica': row.get('J', '').strip(),
            'motivo': row.get('K', '').strip(),
            'estatus_sigebi': row.get('L', '').strip(),
            'observaciones': row.get('M', '').strip()
        }
        movimientos.append(m)

print(f'Processed {len(depreciaciones)} depreciation rows, {len(movimientos)} movement acts.')

# 6. Parse ANEXOS FO-017 (KPIs)
kpi_rows = anexos_data.get('ANEXO_A_FO-017_DESEMPENO', [])
kpis_sga = []
for r_num, row in kpi_rows:
    idx_str = row.get('B', '').strip()
    if idx_str.isdigit():
        kpis_sga.append({
            'numero': int(idx_str),
            'indicador': row.get('C', '').strip(),
            'dimension': row.get('D', '').strip(),
            'formula': row.get('E', '').strip(),
            'meta': row.get('F', '').strip(),
            'frecuencia': row.get('G', '').strip(),
            'responsable': row.get('H', '').strip(),
            'valor_real_q3': safe_float(row.get('I')),
            'valor_real_texto': str(row.get('I', '')).strip()
        })

print(f'Processed {len(kpis_sga)} SGA KPIs (FO-017).')

# 7. Parse ANEXOS FO-018 (Deriva Metrológica)
deriva_rows = anexos_data.get('ANEXO_B_FO-018_DERIVA_METRO', [])
deriva_lecturas = []
for r_num, row in deriva_rows:
    idx_str = row.get('B', '').strip()
    if idx_str.isdigit() and int(idx_str) <= 10:
        deriva_lecturas.append({
            'nro_reg': int(idx_str),
            'tag_pdvsa': 'AMB-LAB-GCMS-001',
            'fecha_medicion': excel_date_to_str(row.get('C')),
            'analista': row.get('D', '').strip(),
            'temperatura_c': float(row.get('E', 0) or 0),
            'humedad_hr': float(row.get('F', 0) or 0),
            'valor_nominal_ppm': float(row.get('G', 0) or 0),
            'valor_medido_ppm': float(row.get('H', 0) or 0),
            'sesgo_absoluto': float(row.get('H', 0) or 0) - float(row.get('G', 0) or 0),
            'consumo_ltm_pct': ((float(row.get('H', 0) or 0) - float(row.get('G', 0) or 0)) / 2.50) * 100
        })

print(f'Processed {len(deriva_lecturas)} drift measurements (FO-018).')

# 8. Parse ANEXOS FO-019 (Acta Revisión por la Dirección)
rev_rows = anexos_data.get('ANEXO_C_FO-019_ACTA_REV_DIR', [])
acuerdos_direccion = []
for r_num, row in rev_rows:
    code = row.get('B', '').strip()
    if code.startswith('D-'):
        acuerdos_direccion.append({
            'codigo': code,
            'requisito_iso': row.get('C', '').strip(),
            'acuerdo_adoptado': row.get('D', '').strip(),
            'responsable': row.get('E', '').strip(),
            'fecha_limite': excel_date_to_str(row.get('F')),
            'recursos_aprobados': row.get('G', '').strip(),
            'mecanismo_verificacion': row.get('H', '').strip()
        })

print(f'Processed {len(acuerdos_direccion)} management review agreements (FO-019).')

# 9. Parse ANEXOS FO-030 (Cierre de Brechas)
brechas_rows = anexos_data.get('ANEXO_D_FO-030_CIERRE_BRECHAS', [])
brechas = []
for r_num, row in brechas_rows:
    idx_str = row.get('B', '').strip()
    if idx_str.isdigit() and int(idx_str) <= 7:
        brechas.append({
            'numero': int(idx_str),
            'cod_brecha': row.get('C', '').strip(),
            'origen_brecha': row.get('D', '').strip(),
            'clausula_iso': row.get('E', '').strip(),
            'laboratorio': row.get('F', '').strip(),
            'descripcion': row.get('G', '').strip(),
            'tipo_accion': row.get('H', '').strip(),
            'causa_raiz_5p': row.get('I', '').strip()
        })

print(f'Processed {len(brechas)} gap closure plans (FO-030).')

# 10. Parse Listas de Parámetros (Master Catalogs)
param_rows = hv_data.get('LISTAS_PARAMETROS', [])
headers = [param_rows[0][1].get(c, '').strip() for c in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O']]
catalogos = {
    'estatus_operativo': [],
    'criticidad_pdvsa': [],
    'tipos_mantenimiento': [],
    'frecuencias_revision': [],
    'condicion_fisica_sudebip': [],
    'catalogo_sudebip_categorias': [],
    'dictamen_metrologico': [],
    'estatus_calibracion': [],
    'tipos_movimiento_sudebip': [],
    'laboratorios_unidades': []
}

for r_num, row in param_rows:
    if r_num < 2:
        continue
    if row.get('A'): catalogos['estatus_operativo'].append(row.get('A').strip())
    if row.get('B'): catalogos['criticidad_pdvsa'].append(row.get('B').strip())
    if row.get('C'): catalogos['tipos_mantenimiento'].append(row.get('C').strip())
    if row.get('D'): catalogos['frecuencias_revision'].append(row.get('D').strip())
    if row.get('E'): catalogos['condicion_fisica_sudebip'].append(row.get('E').strip())
    if row.get('F'): catalogos['catalogo_sudebip_categorias'].append(row.get('F').strip())
    if row.get('G'): catalogos['dictamen_metrologico'].append(row.get('G').strip())
    if row.get('H'): catalogos['estatus_calibracion'].append(row.get('H').strip())
    if row.get('N'): catalogos['tipos_movimiento_sudebip'].append(row.get('N').strip())
    if row.get('O'): catalogos['laboratorios_unidades'].append(row.get('O').strip())

# Clean empty/duplicates
for k in catalogos:
    catalogos[k] = list(dict.fromkeys([v for v in catalogos[k] if v]))

# Add default laboratories from 334 assets
all_labs = list(set([a.get('laboratorio', '') for a in base_sga.get('activos', []) if a.get('laboratorio')]))
for lab in all_labs:
    if lab not in catalogos['laboratorios_unidades']:
        catalogos['laboratorios_unidades'].append(lab)

# Predefined users for Login and demo
usuarios = [
    {
        'id': 'usr-admin-01',
        'email': 'admin@intevep.pdvsa.com',
        'nombre_completo': 'Ing. Carlos Mendoza (Admin)',
        'rol': 'admin',
        'cargo': 'Líder de Calidad y Coordinador SGA',
        'laboratorio': 'Gerencia de Ambiente (GAMB)',
        'clave_demo': 'Admin*2026'
    },
    {
        'id': 'usr-analista-01',
        'email': 'analista@intevep.pdvsa.com',
        'nombre_completo': 'Lcdo. Miguel Arismendi',
        'rol': 'analista',
        'cargo': 'Analista Especialista en Cromatografía',
        'laboratorio': 'Lab. de Cromatografía y Compuestos Orgánicos',
        'clave_demo': 'Analista*2026'
    },
    {
        'id': 'usr-mant-01',
        'email': 'mantenimiento@intevep.pdvsa.com',
        'nombre_completo': 'Ing. Klaus Weber',
        'rol': 'mantenimiento',
        'cargo': 'Especialista en Mantenimiento Instrumental',
        'laboratorio': 'Taller de Mantenimiento Especializado',
        'clave_demo': 'Mant*2026'
    },
    {
        'id': 'usr-sudebip-01',
        'email': 'sudebip@intevep.pdvsa.com',
        'nombre_completo': 'Lcda. Elena Rodríguez',
        'rol': 'sudebip',
        'cargo': 'Custodio Patrimonial de Bienes Públicos',
        'laboratorio': 'Gerencia de Finanzas y Control de Bienes',
        'clave_demo': 'Sudebip*2026'
    },
    {
        'id': 'usr-gerente-01',
        'email': 'gerente@intevep.pdvsa.com',
        'nombre_completo': 'Dr. Roberto Valenzuela',
        'rol': 'gerente',
        'cargo': 'Gerente de Ambiente INTEVEP S.A.',
        'laboratorio': 'Dirección Gerencial GAMB',
        'clave_demo': 'Gerente*2026'
    }
]

# Permissions matrix by role
permisos_roles = {
    'admin': {
        'dashboard': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'hoja_de_vida': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'inventario': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'calibraciones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'mantenimiento': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'comprobaciones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'deriva': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'sudebip': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'desempeno_fo017': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'cierre_brechas_fo030': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'actas_direccion_fo019': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'decisiones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'catalogos_admin': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'usuarios_admin': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True}
    },
    'analista': {
        'dashboard': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'hoja_de_vida': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'inventario': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'calibraciones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'mantenimiento': {'ver': True, 'crear': True, 'editar': False, 'eliminar': False},
        'comprobaciones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'deriva': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'sudebip': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'desempeno_fo017': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'cierre_brechas_fo030': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'actas_direccion_fo019': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'decisiones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'catalogos_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False},
        'usuarios_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False}
    },
    'mantenimiento': {
        'dashboard': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'hoja_de_vida': {'ver': True, 'crear': False, 'editar': True, 'eliminar': False},
        'inventario': {'ver': True, 'crear': False, 'editar': True, 'eliminar': False},
        'calibraciones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'mantenimiento': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'comprobaciones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'deriva': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'sudebip': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'desempeno_fo017': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'cierre_brechas_fo030': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'actas_direccion_fo019': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'decisiones': {'ver': True, 'crear': False, 'editar': True, 'eliminar': False},
        'catalogos_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False},
        'usuarios_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False}
    },
    'sudebip': {
        'dashboard': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'hoja_de_vida': {'ver': True, 'crear': False, 'editar': True, 'eliminar': False},
        'inventario': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'calibraciones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'mantenimiento': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'comprobaciones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'deriva': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'sudebip': {'ver': True, 'crear': True, 'editar': True, 'eliminar': True},
        'desempeno_fo017': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'cierre_brechas_fo030': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'actas_direccion_fo019': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'decisiones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'catalogos_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False},
        'usuarios_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False}
    },
    'gerente': {
        'dashboard': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'hoja_de_vida': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'inventario': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'calibraciones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'mantenimiento': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'comprobaciones': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'deriva': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'sudebip': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'desempeno_fo017': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'cierre_brechas_fo030': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'actas_direccion_fo019': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'decisiones': {'ver': True, 'crear': True, 'editar': True, 'eliminar': False},
        'catalogos_admin': {'ver': True, 'crear': False, 'editar': False, 'eliminar': False},
        'usuarios_admin': {'ver': False, 'crear': False, 'editar': False, 'eliminar': False}
    }
}

# Consolidated JSON payload
consolidated_dataset = {
    'metadata': {
        'version': '2.0.0',
        'sistema': 'Sistema Integrado de Gestión de Activos Físicos (SIGAF)',
        'normas': ['ISO 55001:2024', 'PDVSA MM-02-01-01', 'SUDEBIP/LOBP', 'ISO/IEC 17025:2017', 'ISO 10012:2003', 'LOPCYMAT'],
        'fecha_generacion': datetime.now().isoformat(),
        'total_activos': len(activos_map)
    },
    'usuarios': usuarios,
    'permisos_roles': permisos_roles,
    'catalogos': catalogos,
    'activos': list(activos_map.values()),
    'catalogo_sudebip': base_sga.get('catalogo_sudebip', []),
    'calibraciones': calibraciones,
    'mantenimientos': mantenimientos,
    'comprobaciones': comprobaciones,
    'depreciaciones': depreciaciones,
    'movimientos_sudebip': movimientos,
    'kpis_sga_fo017': kpis_sga,
    'deriva_fo018': deriva_lecturas,
    'acuerdos_fo019': acuerdos_direccion,
    'brechas_fo030': brechas
}

with open('sga_complete_data.json', 'w', encoding='utf-8') as f:
    json.dump(consolidated_dataset, f, ensure_ascii=False, indent=2)

print('Saved sga_complete_data.json successfully.')
