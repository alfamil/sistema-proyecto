import zipfile
import xml.etree.ElementTree as ET
import json
import datetime
import re

def clean_str(val):
    if val is None:
        return ''
    return str(val).strip()

def clean_sql(val):
    if val is None or val == '':
        return 'NULL'
    s = str(val).replace("'", "''").strip()
    return f"'{s}'"

def clean_num(val):
    if val is None or val == '' or str(val).lower() in ['no calculado', 'no evaluado', 'n/a', 'no determinada', 'sin información']:
        return 'NULL'
    try:
        f = float(str(val).replace(',', '.'))
        return str(f)
    except ValueError:
        return 'NULL'

def clean_int(val):
    if val is None or val == '' or str(val).lower() in ['no calculado', 'no evaluado', 'n/a', 'no determinada', 'sin información']:
        return 'NULL'
    try:
        i = int(float(str(val).replace(',', '.')))
        return str(i)
    except ValueError:
        return 'NULL'

def excel_date_to_str(serial):
    try:
        s = float(serial)
        d = datetime.date(1899, 12, 30) + datetime.timedelta(days=s)
        return d.strftime('%Y-%m-%d')
    except:
        return None

def run():
    with zipfile.ZipFile('herramienta_sga.xlsx', 'r') as z:
        shared_strings = []
        if 'xl/sharedStrings.xml' in z.namelist():
            sst_root = ET.fromstring(z.read('xl/sharedStrings.xml'))
            ns = {'ns': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
            for si in sst_root.findall('.//ns:si', ns):
                t_elems = si.findall('.//ns:t', ns)
                shared_strings.append(''.join([t.text for t in t_elems if t.text]))

        wb_root = ET.fromstring(z.read('xl/workbook.xml'))
        ns = {'ns': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
        rels_root = ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
        id_to_target = {rel.attrib['Id']: rel.attrib['Target'] for rel in rels_root}

        def get_sheet_rows(sheet_name):
            for s in wb_root.findall('.//ns:sheet', ns):
                if s.attrib['name'] == sheet_name:
                    target = 'xl/' + id_to_target[s.attrib['{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id']]
                    root = ET.fromstring(z.read(target))
                    rows = []
                    for row in root.findall('.//ns:row', ns):
                        r_idx = int(row.attrib['r'])
                        r_vals = {}
                        for c in row.findall('ns:c', ns):
                            ref = c.attrib['r']
                            t = c.attrib.get('t')
                            v = c.find('ns:v', ns)
                            val = v.text if v is not None else ''
                            if t == 's' and val:
                                val = shared_strings[int(val)]
                            col = ''.join([ch for ch in ref if ch.isalpha()])
                            r_vals[col] = val
                        rows.append((r_idx, r_vals))
                    return rows
            return []

        # 1. Catálogo SUDEBIP
        sudebip_rows = get_sheet_rows('Catálogo Cod. SUDEBIP')
        sudebip_catalog = []
        for r_idx, r in sudebip_rows:
            if r_idx >= 2 and r.get('C') and r.get('D'):
                c_code = clean_str(r.get('C'))
                c_tipo = clean_str(r.get('D'))
                if c_code:
                    sudebip_catalog.append({
                        'codigo': c_code,
                        'tipo_equipo': c_tipo
                    })
        print(f'Catálogo SUDEBIP procesado: {len(sudebip_catalog)} items')

        # 2. Jerarquización
        jer_rows = get_sheet_rows('2. Jerarquización ')
        jer_map = {}
        for r_idx, r in jer_rows:
            if r_idx >= 11 and r.get('B'):
                tag = clean_str(r.get('B'))
                jer_map[tag] = {
                    'ff': clean_int(r.get('E')),
                    'io': clean_int(r.get('F')),
                    'fo': clean_int(r.get('G')),
                    'cm': clean_int(r.get('H')),
                    'sha': clean_int(r.get('I')),
                    'consecuencia': clean_num(r.get('J')),
                    'ic': clean_num(r.get('K')),
                    'categoria_criticidad': clean_str(r.get('L')),
                    'estatus_seleccion': clean_str(r.get('M')),
                    'criterio_accion': clean_str(r.get('N'))
                }

        # 3. Índice Obsolescencia
        obs_rows = get_sheet_rows('3. Índice Obsolescencia Iobs')
        obs_map = {}
        for r_idx, r in obs_rows:
            if r_idx >= 10 and r.get('B'):
                tag = clean_str(r.get('B'))
                obs_map[tag] = {
                    'eol': clean_int(r.get('E')),
                    'rep': clean_int(r.get('F')),
                    'met': clean_int(r.get('G')),
                    'ant': clean_int(r.get('H')),
                    'suma_puntos': clean_int(r.get('I')),
                    'iobs': clean_num(r.get('J')),
                    'estatus_obsolescencia': clean_str(r.get('K'))
                }

        # 4. Consolidación de Decisiones
        dec_rows = get_sheet_rows('6. Consolidación de Decisiones')
        dec_map = {}
        for r_idx, r in dec_rows:
            if r_idx >= 12 and r.get('B'):
                tag = clean_str(r.get('B'))
                date_de = excel_date_to_str(r.get('N'))
                date_do = excel_date_to_str(r.get('Q'))
                dec_map[tag] = {
                    'cruce_resultado': clean_str(r.get('G')),
                    'decision_sugerida_riesgo': clean_str(r.get('H')),
                    'prioridad_oportunidad': clean_str(r.get('J')),
                    'decision_sugerida_oportunidad': clean_str(r.get('K')),
                    'decision_estrategica_final': clean_str(r.get('L')),
                    'responsable_de': clean_str(r.get('M')),
                    'fecha_de': date_de,
                    'decision_operativa': clean_str(r.get('O')),
                    'responsable_do': clean_str(r.get('P')),
                    'fecha_do': date_do
                }

        # 5. Tabla Master (all assets)
        master_rows = get_sheet_rows('Tabla Master')
        assets = []
        for r_idx, r in master_rows:
            if r_idx >= 9 and r.get('I'):
                tag = clean_str(r.get('I'))
                if not tag or tag == 'Código del Equipo':
                    continue
                asset = {
                    'num': clean_int(r.get('H')),
                    'tag_pdvsa': tag,
                    'codigo_sudebip': clean_str(r.get('J')),
                    'codigo_sap': clean_str(r.get('K')),
                    'nombre': clean_str(r.get('L')),
                    'marca': clean_str(r.get('M')),
                    'modelo': clean_str(r.get('N')),
                    'serial': clean_str(r.get('O')),
                    'laboratorio': clean_str(r.get('P')),
                    'criticidad_analista': clean_str(r.get('Q')),
                    'tipo_equipo': clean_str(r.get('R')),
                    'pareto_20': clean_str(r.get('S')) == 'Sí',
                    'categoria_criticidad': clean_str(r.get('T')),
                    'iobs': clean_num(r.get('U')),
                    'estatus_obsolescencia': clean_str(r.get('V')),
                    'nivel_riesgo': clean_num(r.get('W')),
                    'clasificacion_riesgo': clean_str(r.get('X')),
                    'nivel_oportunidad': clean_num(r.get('Y')),
                    'prioridad_oportunidad': clean_str(r.get('Z')),
                    'resultado_cruce': clean_str(r.get('AA')),
                    'jerarquizacion': jer_map.get(tag, None),
                    'obsolescencia': obs_map.get(tag, None),
                    'decision': dec_map.get(tag, None)
                }
                assets.append(asset)

        print(f'Total activos procesados: {len(assets)}')

        with open('/Users/rebeca/Documents/proyectoMama/sga_data.json', 'w', encoding='utf-8') as f:
            json.dump({
                'metadata': {
                    'proyecto': 'SGAF - Sistema de Gestión de Activos Físicos',
                    'institucion': 'PDVSA INTEVEP - Gerencia de Ambiente',
                    'normas': ['ISO 55001:2024', 'PDVSA MM-02-01-01', 'SUDEBIP LOBP', 'ISO 10012', 'ISO 31000'],
                    'total_activos': len(assets),
                    'total_catalogo_sudebip': len(sudebip_catalog)
                },
                'catalogo_sudebip': sudebip_catalog,
                'activos': assets
            }, f, ensure_ascii=False, indent=2)
        print('JSON guardado en sga_data.json')

        generate_sql(sudebip_catalog, assets)

def generate_sql(sudebip_catalog, assets):
    schema_sql = """-- ========================================================================
-- SISTEMA DE GESTIÓN DE ACTIVOS FÍSICOS (SGAF)
-- Estándares: ISO 55001:2024 | PDVSA MM-02-01-01 | SUDEBIP LOBP | ISO 10012
-- PDVSA INTEVEP - Gerencia de Ambiente
-- ========================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Catálogo SUDEBIP de Bienes Públicos
CREATE TABLE IF NOT EXISTS catalogo_sudebip (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(50) UNIQUE NOT NULL,
    tipo_equipo VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Inventario Maestro de Activos
CREATE TABLE IF NOT EXISTS activos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    num INT,
    tag_pdvsa VARCHAR(100) UNIQUE NOT NULL,
    codigo_sudebip VARCHAR(100),
    codigo_sap VARCHAR(100),
    nombre VARCHAR(255) NOT NULL,
    marca VARCHAR(150),
    modelo VARCHAR(150),
    serial VARCHAR(150),
    laboratorio VARCHAR(150),
    criticidad_analista VARCHAR(50),
    tipo_equipo VARCHAR(150),
    pareto_20 BOOLEAN DEFAULT FALSE,
    estado_operativo VARCHAR(50) DEFAULT 'Operativo',
    
    -- Metrología ISO 10012
    es_equipo_analitico BOOLEAN DEFAULT TRUE,
    rango_medicion VARCHAR(150),
    resolucion VARCHAR(150),
    frecuencia_calibracion VARCHAR(50) DEFAULT 'Anual',
    fecha_ultima_calibracion DATE,
    fecha_proxima_calibracion DATE,
    
    -- Ciclo de Vida y Valor ISO 55001:2024
    fecha_puesta_marcha DATE,
    vida_util_fabricante_anos NUMERIC(5, 2) DEFAULT 10,
    capex_costo_adquisicion NUMERIC(15, 2) DEFAULT 0,
    tco_costo_total NUMERIC(15, 2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Jerarquización y Criticidad (PDVSA MM-02-01-01)
CREATE TABLE IF NOT EXISTS jerarquizacion_criticidad (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa VARCHAR(100) NOT NULL,
    ff INT,
    io INT,
    fo INT,
    cm INT,
    sha INT,
    consecuencia NUMERIC(6, 2),
    ic NUMERIC(6, 2),
    categoria_criticidad VARCHAR(50),
    estatus_seleccion VARCHAR(100),
    criterio_accion TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Evaluación de Índice de Obsolescencia (Iobs)
CREATE TABLE IF NOT EXISTS evaluacion_obsolescencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa VARCHAR(100) NOT NULL,
    eol INT,
    rep INT,
    met INT,
    ant INT,
    suma_puntos INT,
    iobs NUMERIC(5, 2),
    estatus_obsolescencia VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Consolidación de Decisiones (ISO 55001 / SAMP)
CREATE TABLE IF NOT EXISTS decisiones_estrategicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa VARCHAR(100) NOT NULL,
    nivel_riesgo NUMERIC(4, 2),
    clasificacion_riesgo VARCHAR(50),
    nivel_oportunidad NUMERIC(4, 2),
    prioridad_oportunidad VARCHAR(100),
    resultado_cruce VARCHAR(100),
    decision_sugerida_riesgo TEXT,
    decision_sugerida_oportunidad TEXT,
    decision_estrategica_final TEXT,
    responsable_de VARCHAR(150),
    fecha_estimada_de DATE,
    decision_operativa TEXT,
    responsable_do VARCHAR(150),
    fecha_estimada_do DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Historial de Fallas
CREATE TABLE IF NOT EXISTS historial_fallas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa VARCHAR(100) NOT NULL,
    fecha_evento DATE NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    tiempo_fuera_servicio_horas NUMERIC(8, 2) DEFAULT 0,
    impacto_operacional VARCHAR(100),
    accion_tomada TEXT,
    tecnico_responsable VARCHAR(150),
    costo_reparacion NUMERIC(12, 2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Políticas RLS (Row Level Security) abiertas para desarrollo / authenticated
ALTER TABLE catalogo_sudebip ENABLE ROW LEVEL SECURITY;
ALTER TABLE activos ENABLE ROW LEVEL SECURITY;
ALTER TABLE jerarquizacion_criticidad ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluacion_obsolescencia ENABLE ROW LEVEL SECURITY;
ALTER TABLE decisiones_estrategicas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historial_fallas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública catalogo_sudebip" ON catalogo_sudebip FOR SELECT USING (true);
CREATE POLICY "Lectura pública activos" ON activos FOR SELECT USING (true);
CREATE POLICY "Modificación activos" ON activos FOR ALL USING (true);
CREATE POLICY "Lectura jerarquizacion" ON jerarquizacion_criticidad FOR ALL USING (true);
CREATE POLICY "Lectura obsolescencia" ON evaluacion_obsolescencia FOR ALL USING (true);
CREATE POLICY "Lectura decisiones" ON decisiones_estrategicas FOR ALL USING (true);
CREATE POLICY "Lectura historial" ON historial_fallas FOR ALL USING (true);
"""

    with open('/Users/rebeca/Documents/proyectoMama/supabase_schema.sql', 'w', encoding='utf-8') as f:
        f.write(schema_sql)
    print('Archivo supabase_schema.sql generado con éxito.')

    seed_lines = [
        "-- ========================================================================",
        "-- SEED DATA: SISTEMA DE GESTIÓN DE ACTIVOS FÍSICOS (SGAF)",
        "-- Datos extraídos de la herramienta oficial PDVSA INTEVEP / SUDEBIP",
        "-- ========================================================================\n"
    ]

    seed_lines.append("-- 1. Catálogo SUDEBIP")
    for item in sudebip_catalog:
        c = clean_sql(item['codigo'])
        t = clean_sql(item['tipo_equipo'])
        seed_lines.append(f"INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ({c}, {t}) ON CONFLICT (codigo) DO NOTHING;")

    seed_lines.append("\n-- 2. Activos, Jerarquización, Obsolescencia y Decisiones")
    seed_lines.append("DO $$")
    seed_lines.append("DECLARE")
    seed_lines.append("    v_act_id UUID;")
    seed_lines.append("BEGIN")

    for a in assets:
        tag = clean_sql(a['tag_pdvsa'])
        num = clean_num(a['num'])
        sud = clean_sql(a['codigo_sudebip'])
        sap = clean_sql(a['codigo_sap'])
        nom = clean_sql(a['nombre'])
        mar = clean_sql(a['marca'])
        mod = clean_sql(a['modelo'])
        ser = clean_sql(a['serial'])
        lab = clean_sql(a['laboratorio'])
        cri = clean_sql(a['criticidad_analista'])
        tip = clean_sql(a['tipo_equipo'])
        par = 'TRUE' if a['pareto_20'] else 'FALSE'

        seed_lines.append(f"""
    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES ({num}, {tag}, {sud}, {sap}, {nom}, {mar}, {mod}, {ser}, {lab}, {cri}, {tip}, {par})
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;
""")

        if a.get('jerarquizacion'):
            j = a['jerarquizacion']
            ff = clean_num(j.get('ff'))
            io = clean_num(j.get('io'))
            fo = clean_num(j.get('fo'))
            cm = clean_num(j.get('cm'))
            sha = clean_num(j.get('sha'))
            c_val = clean_num(j.get('consecuencia'))
            ic = clean_num(j.get('ic'))
            cat = clean_sql(j.get('categoria_criticidad'))
            est = clean_sql(j.get('estatus_seleccion'))
            acc = clean_sql(j.get('criterio_accion'))
            seed_lines.append(f"""    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, {tag}, {ff}, {io}, {fo}, {cm}, {sha}, {c_val}, {ic}, {cat}, {est}, {acc});""")

        if a.get('obsolescencia'):
            o = a['obsolescencia']
            eol = clean_num(o.get('eol'))
            rep = clean_num(o.get('rep'))
            met = clean_num(o.get('met'))
            ant = clean_num(o.get('ant'))
            pts = clean_num(o.get('suma_puntos'))
            iobs = clean_num(o.get('iobs'))
            est_obs = clean_sql(o.get('estatus_obsolescencia'))
            seed_lines.append(f"""    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, {tag}, {eol}, {rep}, {met}, {ant}, {pts}, {iobs}, {est_obs});""")

        if a.get('decision'):
            d = a['decision']
            nr = clean_num(a.get('nivel_riesgo'))
            clas_r = clean_sql(a.get('clasificacion_riesgo'))
            no = clean_num(a.get('nivel_oportunidad'))
            prio_o = clean_sql(a.get('prioridad_oportunidad'))
            cruce = clean_sql(d.get('cruce_resultado'))
            ds_r = clean_sql(d.get('decision_sugerida_riesgo'))
            ds_o = clean_sql(d.get('decision_sugerida_oportunidad'))
            de_f = clean_sql(d.get('decision_estrategica_final'))
            r_de = clean_sql(d.get('responsable_de'))
            f_de = clean_sql(d.get('fecha_de'))
            d_op = clean_sql(d.get('decision_operativa'))
            r_do = clean_sql(d.get('responsable_do'))
            f_do = clean_sql(d.get('fecha_do'))

            seed_lines.append(f"""    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, {tag}, {nr}, {clas_r}, {no}, {prio_o}, {cruce}, {ds_r}, {ds_o}, {de_f}, {r_de}, {f_de}, {d_op}, {r_do}, {f_do});""")

    seed_lines.append("END $$;")

    with open('/Users/rebeca/Documents/proyectoMama/supabase_seed_data.sql', 'w', encoding='utf-8') as f:
        f.write('\n'.join(seed_lines))
    print('Archivo supabase_seed_data.sql generado con éxito.')

if __name__ == '__main__':
    run()

