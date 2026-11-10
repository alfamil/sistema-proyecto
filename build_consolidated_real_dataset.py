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
            return None
        dt = datetime(1899, 12, 30) + timedelta(days=val)
        return dt.strftime('%Y-%m-%d')
    except Exception:
        pass
    s = str(serial).strip()
    for fmt in ('%Y-%m-%d', '%d/%m/%Y', '%d-%m-%Y'):
        try:
            return datetime.strptime(s, fmt).strftime('%Y-%m-%d')
        except Exception:
            pass
    return None

def is_header_or_empty(tag):
    if not tag:
        return True
    t = str(tag).strip().lower()
    return any(h in t for h in ['tag técnico', 'tag tecnico', 'código', 'codigo', 'indicador', 'n°', 'denominación'])

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

print("=== PROCESANDO DATA REAL DE HERRAMIENTA SGA ===")
sga_wb = parse_xlsx_sheets('herramienta_sga.xlsx')
hv_wb = parse_xlsx_sheets('hoja_de_vida_integral.xlsx')
anexos_wb = parse_xlsx_sheets('formularios_anexos_sga.xlsx')

# 1. Catálogo SUDEBIP
sudebip_items = []
for r_num, row in sga_wb.get('Catálogo Cod. SUDEBIP', []):
    if r_num <= 1:
        continue
    cod = clean_str(row.get('C'))
    tipo = clean_str(row.get('D'))
    if cod and tipo and not is_header_or_empty(cod):
        sudebip_items.append({'codigo': cod, 'tipo_equipo': tipo})

# 2. Jerarquización (Sheet 2)
jer_map = {}
for r_num, row in sga_wb.get('2. Jerarquización ', []):
    if r_num <= 10:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
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

# 3. Obsolescencia (Sheet 3)
obs_map = {}
for r_num, row in sga_wb.get('3. Índice Obsolescencia Iobs', []):
    if r_num <= 9:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
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

# 4. Riesgos (Sheet 4)
riesgo_map = {}
for r_num, row in sga_wb.get('4. Evaluación Riesgos y Oport.', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
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

# 5. Matriz Cruce (Sheet 5)
cruce_map = {}
for r_num, row in sga_wb.get('5. Matriz Cruce Iobs vs Riesgo', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
        continue
    cruce_map[tag] = {
        'tag_pdvsa': tag,
        'nivel_riesgo': safe_float(row.get('E')),
        'iobs': safe_float(row.get('F')),
        'resultado_cruce': clean_str(row.get('G')),
        'decision_sugerida': clean_str(row.get('H')),
    }

# 6. Decisiones (Sheet 6)
dec_map = {}
for r_num, row in sga_wb.get('6. Consolidación de Decisiones', []):
    if r_num <= 11:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
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

# Extraer especificaciones técnicas de hoja_de_vida_integral
hv_specs = {}
for r_num, row in hv_wb.get('INVENTARIO_GENERAL', []):
    if r_num <= 4:
        continue
    tag = clean_str(row.get('A'))
    if not tag or is_header_or_empty(tag):
        continue
    hv_specs[tag] = {
        'filial': clean_str(row.get('F')),
        'sede': clean_str(row.get('G')),
        'gerencia': clean_str(row.get('H')),
        'sistema': clean_str(row.get('I')),
        'custodio': clean_str(row.get('J')),
        'etapa_ciclo_vida': clean_str(row.get('K')),
        'fecha_puesta_servicio': excel_date_to_str(row.get('L')),
        'numero_etiqueta_qr': clean_str(row.get('M')),
        'condicion_fisica': clean_str(row.get('N')),
        'costo_adquisicion_usd': safe_float(row.get('O'), 0),
        'clasificacion_sudebip': clean_str(row.get('P')),
        'unidad_administradora': clean_str(row.get('Q')),
        'responsable_patrimonial': clean_str(row.get('R')),
        'rango_medicion': clean_str(row.get('W')),
        'limite_deteccion': clean_str(row.get('Y')),
        'mep': clean_str(row.get('Z')),
        'condiciones_ambientales': clean_str(row.get('AB')),
        'suministro_electrico': clean_str(row.get('AC')),
        'frecuencia_calibracion': clean_str(row.get('AE')),
        'estrategia_mantenimiento': clean_str(row.get('AO')),
        'frecuencia_mantenimiento': clean_str(row.get('AP')),
        'proveedor_tecnico': clean_str(row.get('AR')),
    }

# Compilar los 334 Activos Maestros
activos_list = []
for r_num, row in sga_wb.get('1. Inventario y Pareto 20%', []):
    if r_num <= 8:
        continue
    tag = clean_str(row.get('B'))
    if not tag or is_header_or_empty(tag):
        continue
    
    pareto_str = clean_str(row.get('O')).lower()
    is_pareto = (pareto_str in ['sí', 'si', 'yes', 'true'])
    
    num_val = None
    try:
        num_val = int(float(row.get('A', 0)))
    except Exception:
        num_val = len(activos_list) + 1

    j_data = jer_map.get(tag, {})
    o_data = obs_map.get(tag, {})
    r_data = riesgo_map.get(tag, {})
    c_data = cruce_map.get(tag, {})
    d_data = dec_map.get(tag, {})
    spec = hv_specs.get(tag, {})

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
        'filial': spec.get('filial') or 'PDVSA INTEVEP S.A.',
        'sede': spec.get('sede') or 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'gerencia': spec.get('gerencia') or 'Gerencia de Ambiente',
        'sistema': spec.get('sistema'),
        'custodio': spec.get('custodio'),
        'etapa_ciclo_vida': spec.get('etapa_ciclo_vida') or 'Operación y Mantenimiento',
        'fecha_puesta_servicio': spec.get('fecha_puesta_servicio'),
        'numero_etiqueta_qr': spec.get('numero_etiqueta_qr'),
        'condicion_fisica': spec.get('condicion_fisica') or 'Buena',
        'costo_adquisicion_usd': spec.get('costo_adquisicion_usd') or 0,
        'clasificacion_sudebip': spec.get('clasificacion_sudebip') or 'Equipos Científicos y de Laboratorio (Cat. 2.04.02)',
        'unidad_administradora': spec.get('unidad_administradora') or 'Gerencia de Ambiente - INTEVEP',
        'responsable_patrimonial': spec.get('responsable_patrimonial'),
        'rango_medicion': spec.get('rango_medicion'),
        'limite_deteccion': spec.get('limite_deteccion'),
        'mep': spec.get('mep'),
        'condiciones_ambientales': spec.get('condiciones_ambientales') or 'Temp: 20 ± 2 °C / HR: 45 - 60%',
        'suministro_electrico': spec.get('suministro_electrico') or '110/220 VAC - 60 Hz Regulada',
        'frecuencia_calibracion': spec.get('frecuencia_calibracion') or 'Anual',
        'estrategia_mantenimiento': spec.get('estrategia_mantenimiento') or 'Preventivo Planificado Sistemático y Predictivo',
        'frecuencia_mantenimiento': spec.get('frecuencia_mantenimiento') or 'Trimestral',
        'proveedor_tecnico': spec.get('proveedor_tecnico') or 'Taller Mantenimiento Instrumental INTEVEP',
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

# 8. Extraer Calibraciones, Mantenimientos, etc.
calibraciones = []
for r_num, row in hv_wb.get('HISTORIAL_CALIBRACION_METROLOGI', []):
    if r_num <= 4:
        continue
    tag = clean_str(row.get('A'))
    id_cal = clean_str(row.get('B'))
    if id_cal and tag and not is_header_or_empty(tag):
        f_cal = excel_date_to_str(row.get('D'))
        f_venc = excel_date_to_str(row.get('E'))
        if f_cal and f_venc:
            calibraciones.append({
                'id_calibracion': id_cal,
                'tag_pdvsa': tag,
                'nro_certificado': clean_str(row.get('C')),
                'fecha_calibracion': f_cal,
                'fecha_vencimiento': f_venc,
                'dias_restantes': int(safe_float(row.get('F'), 0)),
                'estatus_metrologico': clean_str(row.get('G')) or 'VIGENTE',
                'entidad_acreditada': clean_str(row.get('H')) or 'SENCAMER',
                'patron_utilizado': clean_str(row.get('I')),
                'desviacion_observada': clean_str(row.get('J')),
                'incertidumbre_u': clean_str(row.get('K')),
                'mep_tolerancia': clean_str(row.get('L')),
                'dictamen': clean_str(row.get('M')) or 'Conforme (Pasa)',
                'precinto_colocado': clean_str(row.get('N')),
                'metrologo_responsable': clean_str(row.get('O')),
                'observaciones': clean_str(row.get('P')),
            })

mantenimientos = []
for r_num, row in hv_wb.get('REGISTRO_MANTENIMIENTO_PDVSA', []):
    if r_num <= 5:
        continue
    tag = clean_str(row.get('A'))
    nro_ot = clean_str(row.get('B'))
    if nro_ot and tag and not is_header_or_empty(tag):
        f_ini = excel_date_to_str(row.get('E'))
        if f_ini:
            mantenimientos.append({
                'nro_ot': nro_ot,
                'tag_pdvsa': tag,
                'tipo_mantenimiento': clean_str(row.get('C')) or 'Preventivo Planificado',
                'codigo_plan_pdvsa': clean_str(row.get('D')),
                'fecha_inicio': f_ini,
                'fecha_cierre': excel_date_to_str(row.get('F')),
                'descripcion': clean_str(row.get('G')) or 'Mantenimiento Preventivo',
                'repuestos_reemplazados': clean_str(row.get('H')),
                'horas_hombre': safe_float(row.get('I'), 0),
                'costo_total_usd': safe_float(row.get('J'), 0),
                'responsable_ejecucion': clean_str(row.get('K')) or 'Taller Mantenimiento INTEVEP',
                'impacto_ensayos_iso17025': clean_str(row.get('L')),
                'requiere_recalibracion': clean_str(row.get('M')).lower() in ['sí', 'si', 'true'],
                'estatus_ot': clean_str(row.get('N')) or 'Cerrada / Completada',
                'aprobado_por': clean_str(row.get('O')),
                'proximo_mantenimiento': excel_date_to_str(row.get('P')),
            })

comprobaciones = []
for r_num, row in hv_wb.get('COMPROBACIONES_INTERMEDIAS', []):
    if r_num <= 4:
        continue
    tag = clean_str(row.get('A'))
    nro_registro = clean_str(row.get('B'))
    if nro_registro and tag and not is_header_or_empty(tag):
        f_comp = excel_date_to_str(row.get('C'))
        if f_comp:
            comprobaciones.append({
                'nro_registro': nro_registro,
                'tag_pdvsa': tag,
                'fecha_comprobacion': f_comp,
                'patron_verificacion': clean_str(row.get('D')),
                'valor_nominal_patron': safe_float(row.get('E'), 0),
                'lectura_instrumento': safe_float(row.get('F'), 0),
                'desviacion_calculada': safe_float(row.get('G'), 0),
                'criterio_aceptacion_mep': safe_float(row.get('H'), 0),
                'dictamen_auto': clean_str(row.get('I')) or 'CONFORME (PASA)',
                'analista_ejecutor': clean_str(row.get('J')),
                'supervisor_validador': clean_str(row.get('K')),
                'rotulado_operativo': clean_str(row.get('L')) or 'ETIQUETA VERDE - EN SERVICIO',
            })

depreciaciones = []
for r_num, row in hv_wb.get('CONTROL_PATRIMONIAL_SUDEBIP', []):
    if r_num <= 5:
        continue
    tag = clean_str(row.get('A'))
    if tag and not is_header_or_empty(tag):
        f_inc = excel_date_to_str(row.get('D'))
        depreciaciones.append({
            'tag_pdvsa': tag,
            'nro_bien_publico': clean_str(row.get('B')),
            'costo_adquisicion_usd': safe_float(row.get('E'), safe_float(row.get('C'), 0)),
            'fecha_incorporacion': f_inc,
            'tasa_salvamento': safe_float(row.get('F'), 0.10),
            'valor_residual_salvamento': safe_float(row.get('G'), 0),
            'base_depreciable_usd': safe_float(row.get('H'), 0),
            'vida_util_anos': int(safe_float(row.get('I'), 10)),
            'meses_uso': int(safe_float(row.get('J'), 0)),
            'depreciacion_mensual_usd': safe_float(row.get('K'), 0),
            'depreciacion_acumulada_usd': safe_float(row.get('L'), 0),
            'valor_neto_libros_usd': safe_float(row.get('M'), 0),
        })

# 9. Extraer Anexos SGA
kpis_fo017 = []
for r_num, row in anexos_wb.get('ANEXO_A_FO-017_DESEMPENO', []):
    if r_num <= 4:
        continue
    ind = clean_str(row.get('B'))
    if ind and not is_header_or_empty(ind):
        val_real = row.get('H')
        kpis_fo017.append({
            'numero': int(safe_float(row.get('A'), len(kpis_fo017) + 1)),
            'indicador': ind,
            'dimension': clean_str(row.get('C')),
            'formula': clean_str(row.get('D')),
            'meta': clean_str(row.get('E')),
            'frecuencia': clean_str(row.get('F')),
            'responsable': clean_str(row.get('G')),
            'valor_real_q3': safe_float(val_real, 0),
            'valor_real_texto': str(val_real) if val_real is not None else ''
        })

deriva_fo018 = []
for r_num, row in anexos_wb.get('ANEXO_B_FO-018_DERIVA_METRO', []):
    if r_num <= 4:
        continue
    tag = clean_str(row.get('A'))
    if tag and not is_header_or_empty(tag):
        deriva_fo018.append({
            'tag_pdvsa': tag,
            'magnitud': clean_str(row.get('B')),
            'ltm_ppm': safe_float(row.get('C'), 2.50),
            'fecha_cal_base': excel_date_to_str(row.get('D')),
            'error_base': safe_float(row.get('E'), 0),
            'fecha_comprobacion_q3': excel_date_to_str(row.get('F')),
            'error_q3': safe_float(row.get('G'), 0),
            'deriva_calculada_ppm': safe_float(row.get('H'), 0),
            'consumo_ltm_pct': safe_float(row.get('I'), 0),
            'estatus_alerta': clean_str(row.get('J')),
            'accion_requerida': clean_str(row.get('K')),
        })

acuerdos_fo019 = []
for r_num, row in anexos_wb.get('ANEXO_C_FO-019_ACTA_REV_DIR', []):
    if r_num <= 4:
        continue
    cod = clean_str(row.get('A'))
    if cod and not is_header_or_empty(cod):
        acuerdos_fo019.append({
            'codigo': cod,
            'requisito_iso': clean_str(row.get('B')),
            'acuerdo_adoptado': clean_str(row.get('C')),
            'responsable': clean_str(row.get('D')),
            'fecha_limite': excel_date_to_str(row.get('E')),
            'recursos_aprobados': clean_str(row.get('F')),
            'mecanismo_verificacion': clean_str(row.get('G')),
            'estatus': clean_str(row.get('H')),
        })

brechas_fo030 = []
for r_num, row in anexos_wb.get('ANEXO_D_FO-030_CIERRE_BRECHAS', []):
    if r_num <= 4:
        continue
    cod = clean_str(row.get('B'))
    if cod and not is_header_or_empty(cod):
        brechas_fo030.append({
            'numero': int(safe_float(row.get('A'), len(brechas_fo030) + 1)),
            'cod_brecha': cod,
            'origen_brecha': clean_str(row.get('C')),
            'clausula_iso': clean_str(row.get('D')),
            'laboratorio': clean_str(row.get('E')),
            'descripcion': clean_str(row.get('F')),
            'tipo_accion': clean_str(row.get('G')),
            'causa_raiz_5p': clean_str(row.get('H')),
            'estatus': clean_str(row.get('I')) or 'En Proceso'
        })

# Usuarios y Roles estándar para login
usuarios = [
    {
        "id": "usr-admin-01",
        "email": "admin@intevep.pdvsa.com",
        "nombre_completo": "Ing. Carlos Mendoza (Admin)",
        "rol": "admin",
        "cargo": "Líder de Calidad y Coordinador SGA",
        "laboratorio": "Gerencia de Ambiente (GAMB)",
        "clave_demo": "Admin*2026"
    },
    {
        "id": "usr-analista-01",
        "email": "analista@intevep.pdvsa.com",
        "nombre_completo": "Lcdo. Miguel Arismendi",
        "rol": "analista",
        "cargo": "Analista Especialista de Laboratorio",
        "laboratorio": "Aire (Calidad de Aire)",
        "clave_demo": "Analista*2026"
    },
    {
        "id": "usr-mant-01",
        "email": "mantenimiento@intevep.pdvsa.com",
        "nombre_completo": "Ing. Klaus Weber",
        "rol": "mantenimiento",
        "cargo": "Especialista en Mantenimiento Instrumental",
        "laboratorio": "Taller de Mantenimiento Especializado",
        "clave_demo": "Mant*2026"
    },
    {
        "id": "usr-sudebip-01",
        "email": "sudebip@intevep.pdvsa.com",
        "nombre_completo": "Lcda. Elena Rodríguez",
        "rol": "sudebip",
        "cargo": "Custodio Patrimonial de Bienes Públicos",
        "laboratorio": "Gerencia de Finanzas y Control de Bienes",
        "clave_demo": "Sudebip*2026"
    },
    {
        "id": "usr-gerente-01",
        "email": "gerente@intevep.pdvsa.com",
        "nombre_completo": "Dra. Rebeca Salazar",
        "rol": "gerente",
        "cargo": "Gerente de Ambiente INTEVEP",
        "laboratorio": "Gerencia de Ambiente (GAMB)",
        "clave_demo": "Gerente*2026"
    }
]

# Matriz de Permisos RBAC
permisos_roles = {
    "admin": {
        "dashboard": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "hoja_de_vida": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "inventario": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "calibraciones": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "mantenimiento": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "comprobaciones": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "deriva_fo018": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "sudebip_deprec": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "decisiones": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "desempeno_fo017": {"ver": True, "crear": True, "editar": True, "eliminar": True},
        "catalogos_admin": {"ver": True, "crear": True, "editar": True, "eliminar": True}
    },
    "analista": {
        "dashboard": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "hoja_de_vida": {"ver": True, "crear": False, "editar": True, "eliminar": False},
        "inventario": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "calibraciones": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "mantenimiento": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "comprobaciones": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "deriva_fo018": {"ver": True, "crear": True, "editar": False, "eliminar": False},
        "sudebip_deprec": {"ver": False, "crear": False, "editar": False, "eliminar": False},
        "decisiones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "desempeno_fo017": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "catalogos_admin": {"ver": False, "crear": False, "editar": False, "eliminar": False}
    },
    "mantenimiento": {
        "dashboard": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "hoja_de_vida": {"ver": True, "crear": False, "editar": True, "eliminar": False},
        "inventario": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "calibraciones": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "mantenimiento": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "comprobaciones": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "deriva_fo018": {"ver": True, "crear": True, "editar": False, "eliminar": False},
        "sudebip_deprec": {"ver": False, "crear": False, "editar": False, "eliminar": False},
        "decisiones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "desempeno_fo017": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "catalogos_admin": {"ver": False, "crear": False, "editar": False, "eliminar": False}
    },
    "sudebip": {
        "dashboard": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "hoja_de_vida": {"ver": True, "crear": False, "editar": True, "eliminar": False},
        "inventario": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "calibraciones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "mantenimiento": {"ver": False, "crear": False, "editar": False, "eliminar": False},
        "comprobaciones": {"ver": False, "crear": False, "editar": False, "eliminar": False},
        "deriva_fo018": {"ver": False, "crear": False, "editar": False, "eliminar": False},
        "sudebip_deprec": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "decisiones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "desempeno_fo017": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "catalogos_admin": {"ver": False, "crear": False, "editar": False, "eliminar": False}
    },
    "gerente": {
        "dashboard": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "hoja_de_vida": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "inventario": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "calibraciones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "mantenimiento": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "comprobaciones": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "deriva_fo018": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "sudebip_deprec": {"ver": True, "crear": False, "editar": False, "eliminar": False},
        "decisiones": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "desempeno_fo017": {"ver": True, "crear": True, "editar": True, "eliminar": False},
        "catalogos_admin": {"ver": True, "crear": False, "editar": False, "eliminar": False}
    }
}

catalogos = {
    "laboratorios": [
        "Aire (Calidad de Aire)",
        "Efluentes (Tratabilidad de Efluentes)",
        "Biotecnología",
        "Ecotoxicología",
        "Química Ambiental",
        "Desechos ( Tratabilidad de Desechos)",
        "Gerencia de Ambiente"
    ],
    "estados_operativos": [
        "Operativo",
        "En Calibración",
        "En Mantenimiento",
        "Fuera de Servicio",
        "Desincorporado"
    ],
    "clasificaciones_funcionales": [
        "Instrumento de Medición",
        "Equipo de Ensayo y Análisis",
        "Equipo Auxiliar de Laboratorio",
        "Equipo de Muestreo de Campo",
        "Sistema de Tratamiento"
    ],
    "frecuencias_mantenimiento": [
        "Mensual",
        "Bimestral",
        "Trimestral",
        "Semestral",
        "Anual"
    ],
    "normas_tecnicas": [
        "ISO 55001:2024",
        "PDVSA MM-02-01-01",
        "ISO 10012:2003",
        "ISO/IEC 17025:2017",
        "SUDEBIP/LOBP",
        "LOPCYMAT"
    ]
}

consolidated = {
    "metadata": {
        "version": "3.1.0",
        "sistema": "Sistema Integrado de Gestión de Activos Físicos (SIGAF)",
        "fuente_oficial": "herramienta_sga.xlsx",
        "fecha_generacion": datetime.now().isoformat(),
        "total_activos": len(activos_list),
        "total_pareto_20": len([a for a in activos_list if a['pareto_20']]),
        "total_sudebip": len(sudebip_items),
        "total_calibraciones": len(calibraciones),
        "total_mantenimientos": len(mantenimientos),
        "total_comprobaciones": len(comprobaciones),
        "total_kpis": len(kpis_fo017),
        "total_deriva": len(deriva_fo018),
        "total_acuerdos": len(acuerdos_fo019),
        "total_brechas": len(brechas_fo030)
    },
    "usuarios": usuarios,
    "permisos_roles": permisos_roles,
    "catalogos": catalogos,
    "catalogo_sudebip": sudebip_items,
    "activos": activos_list,
    "calibraciones": calibraciones,
    "mantenimientos": mantenimientos,
    "comprobaciones": comprobaciones,
    "depreciaciones": depreciaciones,
    "kpis_sga_fo017": kpis_fo017,
    "deriva_fo018": deriva_fo018,
    "acuerdos_fo019": acuerdos_fo019,
    "brechas_fo030": brechas_fo030
}

with open('sga_data.json', 'w', encoding='utf-8') as f:
    json.dump(consolidated, f, ensure_ascii=False, indent=2)

print(f"sga_data.json generado exitosamente con {len(activos_list)} activos reales.")
print(f"Calibraciones válidas: {len(calibraciones)}")
print(f"Mantenimientos válidos: {len(mantenimientos)}")
print(f"Depreciaciones válidas: {len(depreciaciones)}")
print(f"KPIs FO-017 válidos: {len(kpis_fo017)}")
