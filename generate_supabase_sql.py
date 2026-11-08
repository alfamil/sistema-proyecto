import json

with open('sga_complete_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

def clean_sql_str(val):
    if val is None:
        return 'NULL'
    val_str = str(val).replace("'", "''")
    return f"'{val_str}'"

def clean_sql_num(val, default=0):
    if val is None or val == '':
        return str(default)
    try:
        return str(float(val))
    except Exception:
        return str(default)

# 1. GENERATE SCHEMA
schema_sql = """-- ==============================================================================
-- SIGAF INTEVEP • SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS
-- SCHEMA UPGRADE: ISO 55001:2024 / PDVSA MM-02-01-01 / ISO 17025 / ISO 10012 / SUDEBIP
-- ==============================================================================

-- 1. EXTENDER TABLA DE ACTIVOS CON ESPECIFICACIONES TÉCNICAS Y METROLÓGICAS
ALTER TABLE IF EXISTS activos 
  ADD COLUMN IF NOT EXISTS filial TEXT DEFAULT 'PDVSA INTEVEP S.A.',
  ADD COLUMN IF NOT EXISTS sede TEXT DEFAULT 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
  ADD COLUMN IF NOT EXISTS sistema TEXT,
  ADD COLUMN IF NOT EXISTS custodio TEXT,
  ADD COLUMN IF NOT EXISTS etapa_ciclo_vida TEXT DEFAULT 'Operación y Mantenimiento',
  ADD COLUMN IF NOT EXISTS fecha_puesta_servicio DATE,
  ADD COLUMN IF NOT EXISTS numero_etiqueta_qr TEXT,
  ADD COLUMN IF NOT EXISTS condicion_fisica TEXT DEFAULT 'Buena',
  ADD COLUMN IF NOT EXISTS costo_adquisicion_usd NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS clasificacion_sudebip TEXT DEFAULT 'Equipos Científicos, de Medición y Lab. (Cat. 2.04.02)',
  ADD COLUMN IF NOT EXISTS unidad_administradora TEXT DEFAULT 'Gerencia de Ambiente - INTEVEP',
  ADD COLUMN IF NOT EXISTS responsable_patrimonial TEXT,
  ADD COLUMN IF NOT EXISTS nro_orden_compra TEXT,
  ADD COLUMN IF NOT EXISTS responsable_custodia TEXT,
  ADD COLUMN IF NOT EXISTS estatus_sigebi TEXT DEFAULT 'Registrado e Incorporado Conforme',
  ADD COLUMN IF NOT EXISTS rango_medicion TEXT,
  ADD COLUMN IF NOT EXISTS rango_temperatura TEXT,
  ADD COLUMN IF NOT EXISTS limite_deteccion TEXT,
  ADD COLUMN IF NOT EXISTS mep TEXT,
  ADD COLUMN IF NOT EXISTS software_version TEXT,
  ADD COLUMN IF NOT EXISTS condiciones_ambientales TEXT,
  ADD COLUMN IF NOT EXISTS suministro_electrico TEXT,
  ADD COLUMN IF NOT EXISTS precinto_seguridad TEXT,
  ADD COLUMN IF NOT EXISTS frecuencia_calibracion TEXT DEFAULT 'Anual',
  ADD COLUMN IF NOT EXISTS frecuencia_comprobacion TEXT DEFAULT 'Mensual',
  ADD COLUMN IF NOT EXISTS riesgos_fisicos TEXT,
  ADD COLUMN IF NOT EXISTS epp_operacion TEXT,
  ADD COLUMN IF NOT EXISTS riesgos_quimicos TEXT,
  ADD COLUMN IF NOT EXISTS epp_mantenimiento TEXT,
  ADD COLUMN IF NOT EXISTS riesgos_termicos TEXT,
  ADD COLUMN IF NOT EXISTS procedimiento_loto TEXT,
  ADD COLUMN IF NOT EXISTS dispositivos_seguridad TEXT,
  ADD COLUMN IF NOT EXISTS ubicacion_emergencia TEXT,
  ADD COLUMN IF NOT EXISTS estrategia_mantenimiento TEXT DEFAULT 'Preventivo Planificado y Predictivo',
  ADD COLUMN IF NOT EXISTS frecuencia_mantenimiento TEXT DEFAULT 'Trimestral',
  ADD COLUMN IF NOT EXISTS codigo_plan_pdvsa TEXT,
  ADD COLUMN IF NOT EXISTS proveedor_tecnico TEXT,
  ADD COLUMN IF NOT EXISTS vida_util_anos NUMERIC DEFAULT 10,
  ADD COLUMN IF NOT EXISTS tasa_salvamento NUMERIC DEFAULT 0.10;

-- 2. TABLA DE CATÁLOGOS Y PARÁMETROS MAESTROS DINÁMICOS (SELECTS SIN CÓDIGO QUEMADO)
CREATE TABLE IF NOT EXISTS catalogos_parametros (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  categoria TEXT NOT NULL,
  codigo TEXT NOT NULL,
  nombre TEXT NOT NULL,
  descripcion TEXT,
  orden INT DEFAULT 0,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABLA DE USUARIOS Y ROLES DEL SISTEMA
CREATE TABLE IF NOT EXISTS usuarios_sistema (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  nombre_completo TEXT NOT NULL,
  rol TEXT NOT NULL CHECK (rol IN ('admin', 'analista', 'mantenimiento', 'sudebip', 'gerente')),
  cargo TEXT,
  laboratorio TEXT,
  clave_demo TEXT,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABLA DE CALIBRACIONES Y CONFIRMACIÓN METROLÓGICA (ISO 10012 / ISO 17025)
CREATE TABLE IF NOT EXISTS calibraciones_metrologicas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_calibracion TEXT NOT NULL,
  tag_pdvsa TEXT NOT NULL,
  nro_certificado TEXT NOT NULL,
  fecha_calibracion DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL,
  dias_restantes INT,
  estatus_metrologico TEXT NOT NULL,
  entidad_acreditada TEXT NOT NULL,
  patron_utilizado TEXT,
  desviacion_observada TEXT,
  incertidumbre_u TEXT,
  mep_tolerancia TEXT,
  dictamen TEXT NOT NULL CHECK (dictamen IN ('Conforme (Pasa)', 'Conforme con Restricciones', 'No Conforme (No Pasa / Requiere Ajuste)')),
  precinto_colocado TEXT,
  metrologo_responsable TEXT,
  observaciones TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. TABLA DE REGISTRO DE MANTENIMIENTO Y ÓRDENES DE TRABAJO (PDVSA MM-02-01-01 / FO-008)
CREATE TABLE IF NOT EXISTS mantenimientos_pdvsa (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nro_ot TEXT NOT NULL,
  tag_pdvsa TEXT NOT NULL,
  tipo_mantenimiento TEXT NOT NULL,
  codigo_plan_pdvsa TEXT,
  fecha_inicio DATE NOT NULL,
  fecha_cierre DATE,
  descripcion TEXT NOT NULL,
  repuestos_reemplazados TEXT,
  horas_hombre NUMERIC DEFAULT 0,
  costo_total_usd NUMERIC DEFAULT 0,
  responsable_ejecucion TEXT NOT NULL,
  impacto_ensayos_iso17025 TEXT,
  requiere_recalibracion BOOLEAN DEFAULT FALSE,
  estatus_ot TEXT NOT NULL DEFAULT 'Cerrada / Completada',
  aprobado_por TEXT,
  proximo_mantenimiento DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. TABLA DE COMPROBACIONES INTERMEDIAS (ISO 17025 Cl. 6.4.10)
CREATE TABLE IF NOT EXISTS comprobaciones_intermedias (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_comprobacion TEXT NOT NULL,
  tag_pdvsa TEXT NOT NULL,
  fecha_verificacion DATE NOT NULL,
  parametro_verificado TEXT NOT NULL,
  patron_referencia TEXT NOT NULL,
  limite_min NUMERIC NOT NULL,
  limite_max NUMERIC NOT NULL,
  valor_experimental NUMERIC NOT NULL,
  dictamen_auto TEXT NOT NULL,
  desviacion_observada TEXT,
  rotulado_operativo TEXT NOT NULL,
  analista_responsable TEXT NOT NULL,
  observaciones TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. TABLA DE DERIVA METROLÓGICA (AMB-GEN-SGA-FO-018)
CREATE TABLE IF NOT EXISTS deriva_metrologica_lecturas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nro_reg INT NOT NULL,
  tag_pdvsa TEXT NOT NULL,
  fecha_medicion DATE NOT NULL,
  analista TEXT NOT NULL,
  temperatura_c NUMERIC,
  humedad_hr NUMERIC,
  valor_nominal_ppm NUMERIC NOT NULL,
  valor_medido_ppm NUMERIC NOT NULL,
  sesgo_absoluto NUMERIC NOT NULL,
  consumo_ltm_pct NUMERIC NOT NULL,
  zona_riesgo TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. TABLA DE CONTROL PATRIMONIAL Y DEPRECIACIÓN SUDEBIP (LÍNEA RECTA LOBP)
CREATE TABLE IF NOT EXISTS control_patrimonial_depreciacion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tag_pdvsa TEXT NOT NULL UNIQUE,
  codigo_sigebi TEXT,
  denominacion TEXT NOT NULL,
  fecha_incorporacion DATE,
  costo_adquisicion_usd NUMERIC DEFAULT 0,
  tasa_salvamento NUMERIC DEFAULT 0.10,
  valor_residual_salvamento NUMERIC DEFAULT 0,
  base_depreciable_usd NUMERIC DEFAULT 0,
  vida_util_anos NUMERIC DEFAULT 10,
  meses_uso INT DEFAULT 0,
  depreciacion_mensual_usd NUMERIC DEFAULT 0,
  depreciacion_acumulada_usd NUMERIC DEFAULT 0,
  valor_neto_libros_usd NUMERIC DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. TABLA DE ACTAS Y MOVIMIENTOS PATRIMONIALES SUDEBIP
CREATE TABLE IF NOT EXISTS actas_movimientos_sudebip (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nro_acta TEXT NOT NULL,
  tag_pdvsa TEXT NOT NULL,
  fecha_movimiento DATE NOT NULL,
  tipo_movimiento TEXT NOT NULL,
  unidad_emisora TEXT NOT NULL,
  unidad_receptora TEXT NOT NULL,
  responsable_entrega TEXT NOT NULL,
  responsable_receptor TEXT NOT NULL,
  nro_autorizacion TEXT,
  condicion_fisica TEXT DEFAULT 'Buena',
  motivo TEXT,
  estatus_sigebi TEXT DEFAULT 'Aprobado',
  observaciones TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. TABLA DE TABLERO DE 9 KPIS DEL SGA (AMB-GEN-SGA-FO-017)
CREATE TABLE IF NOT EXISTS desempeno_sga_fo017 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero INT NOT NULL,
  indicador TEXT NOT NULL,
  dimension TEXT NOT NULL,
  formula TEXT NOT NULL,
  meta TEXT NOT NULL,
  frecuencia TEXT NOT NULL,
  responsable TEXT NOT NULL,
  valor_real_q3 NUMERIC,
  valor_real_texto TEXT,
  periodo TEXT DEFAULT 'Trimestre Q3 2026',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. TABLA DE ACUERDOS DE REVISIÓN POR LA DIRECCIÓN (AMB-GEN-SGA-FO-019)
CREATE TABLE IF NOT EXISTS acuerdos_direccion_fo019 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo TEXT NOT NULL,
  requisito_iso TEXT NOT NULL,
  acuerdo_adoptado TEXT NOT NULL,
  responsable TEXT NOT NULL,
  fecha_limite DATE,
  recursos_aprobados TEXT,
  mecanismo_verificacion TEXT,
  estatus TEXT DEFAULT 'Aprobado',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 12. TABLA DE PLAN DE CIERRE DE BRECHAS Y MEJORA CONTINUA (AMB-GEN-SGA-FO-030)
CREATE TABLE IF NOT EXISTS cierre_brechas_fo030 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  numero INT NOT NULL,
  cod_brecha TEXT NOT NULL,
  origen_brecha TEXT NOT NULL,
  clausula_iso TEXT NOT NULL,
  laboratorio TEXT NOT NULL,
  descripcion TEXT NOT NULL,
  tipo_accion TEXT NOT NULL,
  causa_raiz_5p TEXT NOT NULL,
  estatus TEXT DEFAULT 'En Proceso',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- VISTA DE ALERTAS MENSUALES (SEMÁFORO DE VENCIMIENTOS METROLÓGICOS)
CREATE OR REPLACE VIEW v_alertas_mensuales_calibracion AS
SELECT 
  c.id,
  c.tag_pdvsa,
  a.nombre AS nombre_activo,
  a.laboratorio,
  c.nro_certificado,
  c.fecha_calibracion,
  c.fecha_vencimiento,
  (c.fecha_vencimiento - CURRENT_DATE) AS dias_restantes_calculados,
  CASE 
    WHEN c.fecha_vencimiento < CURRENT_DATE THEN 'VENCIDA'
    WHEN (c.fecha_vencimiento - CURRENT_DATE) <= 30 THEN 'POR_VENCER'
    ELSE 'VIGENTE'
  END AS semaforo_alerta,
  c.entidad_acreditada,
  c.dictamen
FROM calibraciones_metrologicas c
JOIN activos a ON a.tag_pdvsa = c.tag_pdvsa;

-- RLS: HABILITAR SEGURIDAD Y PERMITIR ACCESO CON PUBLIC ANON KEY
ALTER TABLE catalogos_parametros ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE calibraciones_metrologicas ENABLE ROW LEVEL SECURITY;
ALTER TABLE mantenimientos_pdvsa ENABLE ROW LEVEL SECURITY;
ALTER TABLE comprobaciones_intermedias ENABLE ROW LEVEL SECURITY;
ALTER TABLE deriva_metrologica_lecturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE control_patrimonial_depreciacion ENABLE ROW LEVEL SECURITY;
ALTER TABLE actas_movimientos_sudebip ENABLE ROW LEVEL SECURITY;
ALTER TABLE desempeno_sga_fo017 ENABLE ROW LEVEL SECURITY;
ALTER TABLE acuerdos_direccion_fo019 ENABLE ROW LEVEL SECURITY;
ALTER TABLE cierre_brechas_fo030 ENABLE ROW LEVEL SECURITY;

-- POLICIES DE ACCESO PÚBLICO / ANON PARA APP
CREATE POLICY "Public read catalogos" ON catalogos_parametros FOR SELECT USING (true);
CREATE POLICY "Public write catalogos" ON catalogos_parametros FOR ALL USING (true);

CREATE POLICY "Public read usuarios" ON usuarios_sistema FOR SELECT USING (true);
CREATE POLICY "Public write usuarios" ON usuarios_sistema FOR ALL USING (true);

CREATE POLICY "Public read calibraciones" ON calibraciones_metrologicas FOR SELECT USING (true);
CREATE POLICY "Public write calibraciones" ON calibraciones_metrologicas FOR ALL USING (true);

CREATE POLICY "Public read mantenimientos" ON mantenimientos_pdvsa FOR SELECT USING (true);
CREATE POLICY "Public write mantenimientos" ON mantenimientos_pdvsa FOR ALL USING (true);

CREATE POLICY "Public read comprobaciones" ON comprobaciones_intermedias FOR SELECT USING (true);
CREATE POLICY "Public write comprobaciones" ON comprobaciones_intermedias FOR ALL USING (true);

CREATE POLICY "Public read deriva" ON deriva_metrologica_lecturas FOR SELECT USING (true);
CREATE POLICY "Public write deriva" ON deriva_metrologica_lecturas FOR ALL USING (true);

CREATE POLICY "Public read depreciacion" ON control_patrimonial_depreciacion FOR SELECT USING (true);
CREATE POLICY "Public write depreciacion" ON control_patrimonial_depreciacion FOR ALL USING (true);

CREATE POLICY "Public read movimientos" ON actas_movimientos_sudebip FOR SELECT USING (true);
CREATE POLICY "Public write movimientos" ON actas_movimientos_sudebip FOR ALL USING (true);

CREATE POLICY "Public read desempeno" ON desempeno_sga_fo017 FOR SELECT USING (true);
CREATE POLICY "Public write desempeno" ON desempeno_sga_fo017 FOR ALL USING (true);

CREATE POLICY "Public read acuerdos" ON acuerdos_direccion_fo019 FOR SELECT USING (true);
CREATE POLICY "Public write acuerdos" ON acuerdos_direccion_fo019 FOR ALL USING (true);

CREATE POLICY "Public read brechas" ON cierre_brechas_fo030 FOR SELECT USING (true);
CREATE POLICY "Public write brechas" ON cierre_brechas_fo030 FOR ALL USING (true);
"""

with open('supabase_upgrade_schema.sql', 'w', encoding='utf-8') as f:
    f.write(schema_sql)

print('Generated supabase_upgrade_schema.sql')

# 2. GENERATE SEED DATA
seed_lines = [
    "-- ==============================================================================",
    "-- SIGAF INTEVEP • SEED DATA: DATOS INTEGRALES DE LOS FORMULARIOS Y ANEXOS",
    "-- ==============================================================================\n"
]

# Insert Catalogos
seed_lines.append("-- 1. INSERTAR CATÁLOGOS DINÁMICOS")
cat_map = data.get('catalogos', {})
for cat_name, items in cat_map.items():
    for idx, item in enumerate(items):
        code = f"{cat_name.upper()[:4]}-{idx+1:02d}"
        seed_lines.append(
            f"INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) "
            f"VALUES ({clean_sql_str(cat_name)}, {clean_sql_str(code)}, {clean_sql_str(item)}, {idx+1}) "
            f"ON CONFLICT DO NOTHING;"
        )

# Insert Usuarios
seed_lines.append("\n-- 2. INSERTAR USUARIOS PREDEFINIDOS")
for u in data.get('usuarios', []):
    seed_lines.append(
        f"INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo) "
        f"VALUES ({clean_sql_str(u['id'])}, {clean_sql_str(u['email'])}, {clean_sql_str(u['nombre_completo'])}, "
        f"{clean_sql_str(u['rol'])}, {clean_sql_str(u['cargo'])}, {clean_sql_str(u['laboratorio'])}, {clean_sql_str(u['clave_demo'])}) "
        f"ON CONFLICT (email) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;"
    )

# Update deep profile attributes on key assets
seed_lines.append("\n-- 3. ACTUALIZAR DETALLES TÉCNICOS EN ACTIVOS MAESTROS")
for a in data.get('activos', [])[:10]:
    if a.get('mep') or a.get('rango_medicion'):
        seed_lines.append(
            f"UPDATE activos SET "
            f"rango_medicion = {clean_sql_str(a.get('rango_medicion'))}, "
            f"mep = {clean_sql_str(a.get('mep'))}, "
            f"software_version = {clean_sql_str(a.get('software_version'))}, "
            f"condiciones_ambientales = {clean_sql_str(a.get('condiciones_ambientales'))}, "
            f"suministro_electrico = {clean_sql_str(a.get('suministro_electrico'))}, "
            f"precinto_seguridad = {clean_sql_str(a.get('precinto_seguridad'))}, "
            f"riesgos_fisicos = {clean_sql_str(a.get('riesgos_fisicos'))}, "
            f"epp_operacion = {clean_sql_str(a.get('epp_operacion'))}, "
            f"riesgos_quimicos = {clean_sql_str(a.get('riesgos_quimicos'))}, "
            f"costo_adquisicion_usd = {clean_sql_num(a.get('costo_adquisicion_usd'))}, "
            f"vida_util_anos = {clean_sql_num(a.get('vida_util_anos'), 10)}, "
            f"tasa_salvamento = {clean_sql_num(a.get('tasa_salvamento'), 0.1)} "
            f"WHERE tag_pdvsa = {clean_sql_str(a.get('tag_pdvsa'))};"
        )

# Insert Calibraciones
seed_lines.append("\n-- 4. INSERTAR CALIBRACIONES METROLÓGICAS (ISO 10012)")
for c in data.get('calibraciones', []):
    seed_lines.append(
        f"INSERT INTO calibraciones_metrologicas (id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes, estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u, mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones) "
        f"VALUES ({clean_sql_str(c['id_calibracion'])}, {clean_sql_str(c['tag_pdvsa'])}, {clean_sql_str(c['nro_certificado'])}, "
        f"'{c['fecha_calibracion']}', '{c['fecha_vencimiento']}', {c['dias_restantes']}, {clean_sql_str(c['estatus_metrologico'])}, "
        f"{clean_sql_str(c['entidad_acreditada'])}, {clean_sql_str(c.get('patron_utilizado'))}, {clean_sql_str(c.get('desviacion_observada'))}, "
        f"{clean_sql_str(c.get('incertidumbre_u'))}, {clean_sql_str(c.get('mep_tolerancia'))}, {clean_sql_str(c.get('dictamen'))}, "
        f"{clean_sql_str(c.get('precinto_colocado'))}, {clean_sql_str(c.get('metrologo_responsable'))}, {clean_sql_str(c.get('observaciones'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Mantenimientos
seed_lines.append("\n-- 5. INSERTAR MANTENIMIENTOS PDVSA (MM-02-01-01 / FO-008)")
for m in data.get('mantenimientos', []):
    seed_lines.append(
        f"INSERT INTO mantenimientos_pdvsa (nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion, repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025, requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento) "
        f"VALUES ({clean_sql_str(m['nro_ot'])}, {clean_sql_str(m['tag_pdvsa'])}, {clean_sql_str(m['tipo_mantenimiento'])}, {clean_sql_str(m.get('codigo_plan_pdvsa'))}, "
        f"'{m['fecha_inicio']}', {clean_sql_str(m.get('fecha_cierre'))}, {clean_sql_str(m['descripcion'])}, {clean_sql_str(m.get('repuestos_reemplazados'))}, "
        f"{clean_sql_num(m.get('horas_hombre'))}, {clean_sql_num(m.get('costo_total_usd'))}, {clean_sql_str(m['responsable_ejecucion'])}, "
        f"{clean_sql_str(m.get('impacto_ensayos_iso17025'))}, {m.get('requiere_recalibracion', False)}, {clean_sql_str(m.get('estatus_ot', 'Cerrada / Completada'))}, "
        f"{clean_sql_str(m.get('aprobado_por'))}, {clean_sql_str(m.get('proximo_mantenimiento'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Comprobaciones Intermedias
seed_lines.append("\n-- 6. INSERTAR COMPROBACIONES INTERMEDIAS (ISO 17025)")
for ci in data.get('comprobaciones', []):
    seed_lines.append(
        f"INSERT INTO comprobaciones_intermedias (id_comprobacion, tag_pdvsa, fecha_verificacion, parametro_verificado, patron_referencia, limite_min, limite_max, valor_experimental, dictamen_auto, desviacion_observada, rotulado_operativo, analista_responsable, observaciones) "
        f"VALUES ({clean_sql_str(ci['id_comprobacion'])}, {clean_sql_str(ci['tag_pdvsa'])}, '{ci['fecha_verificacion']}', {clean_sql_str(ci['parametro_verificado'])}, "
        f"{clean_sql_str(ci['patron_referencia'])}, {clean_sql_num(ci['limite_min'])}, {clean_sql_num(ci['limite_max'])}, {clean_sql_num(ci['valor_experimental'])}, "
        f"{clean_sql_str(ci['dictamen_auto'])}, {clean_sql_str(ci.get('desviacion_observada'))}, {clean_sql_str(ci['rotulado_operativo'])}, "
        f"{clean_sql_str(ci['analista_responsable'])}, {clean_sql_str(ci.get('observaciones'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Deriva Metrológica
seed_lines.append("\n-- 7. INSERTAR LECTURAS DE DERIVA METROLÓGICA (AMB-GEN-SGA-FO-018)")
for d in data.get('deriva_fo018', []):
    zona = 'Verde (<60%)' if d['consumo_ltm_pct'] < 60 else ('Amarilla (60-79%)' if d['consumo_ltm_pct'] < 80 else 'Roja (>=80%)')
    seed_lines.append(
        f"INSERT INTO deriva_metrologica_lecturas (nro_reg, tag_pdvsa, fecha_medicion, analista, temperatura_c, humedad_hr, valor_nominal_ppm, valor_medido_ppm, sesgo_absoluto, consumo_ltm_pct, zona_riesgo) "
        f"VALUES ({d['nro_reg']}, {clean_sql_str(d['tag_pdvsa'])}, '{d['fecha_medicion']}', {clean_sql_str(d['analista'])}, "
        f"{clean_sql_num(d.get('temperatura_c'))}, {clean_sql_num(d.get('humedad_hr'))}, {clean_sql_num(d['valor_nominal_ppm'])}, "
        f"{clean_sql_num(d['valor_medido_ppm'])}, {clean_sql_num(d['sesgo_absoluto'])}, {clean_sql_num(d['consumo_ltm_pct'])}, {clean_sql_str(zona)}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Control Patrimonial Depreciacion
seed_lines.append("\n-- 8. INSERTAR DEPRECIACIÓN PATRIMONIAL SUDEBIP (LÍNEA RECTA)")
for dp in data.get('depreciaciones', []):
    seed_lines.append(
        f"INSERT INTO control_patrimonial_depreciacion (tag_pdvsa, codigo_sigebi, denominacion, fecha_incorporacion, costo_adquisicion_usd, tasa_salvamento, valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso, depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd) "
        f"VALUES ({clean_sql_str(dp['tag_pdvsa'])}, {clean_sql_str(dp.get('codigo_sigebi'))}, {clean_sql_str(dp['denominacion'])}, {clean_sql_str(dp.get('fecha_incorporacion'))}, "
        f"{clean_sql_num(dp.get('costo_adquisicion_usd'))}, {clean_sql_num(dp.get('tasa_salvamento'), 0.1)}, {clean_sql_num(dp.get('valor_residual_salvamento'))}, "
        f"{clean_sql_num(dp.get('base_depreciable_usd'))}, {clean_sql_num(dp.get('vida_util_anos'), 10)}, {dp.get('meses_uso', 0)}, "
        f"{clean_sql_num(dp.get('depreciacion_mensual_usd'))}, {clean_sql_num(dp.get('depreciacion_acumulada_usd'))}, {clean_sql_num(dp.get('valor_neto_libros_usd'))}) "
        f"ON CONFLICT (tag_pdvsa) DO UPDATE SET valor_neto_libros_usd = EXCLUDED.valor_neto_libros_usd;"
    )

# Insert Actas de Movimiento
seed_lines.append("\n-- 9. INSERTAR ACTAS DE MOVIMIENTO Y TRANSFERENCIA SUDEBIP")
for mov in data.get('movimientos_sudebip', []):
    seed_lines.append(
        f"INSERT INTO actas_movimientos_sudebip (nro_acta, tag_pdvsa, fecha_movimiento, tipo_movimiento, unidad_emisora, unidad_receptora, responsable_entrega, responsable_receptor, nro_autorizacion, condicion_fisica, motivo, estatus_sigebi, observaciones) "
        f"VALUES ({clean_sql_str(mov['nro_acta'])}, {clean_sql_str(mov['tag_pdvsa'])}, '{mov['fecha_movimiento']}', {clean_sql_str(mov['tipo_movimiento'])}, "
        f"{clean_sql_str(mov['unidad_emisora'])}, {clean_sql_str(mov['unidad_receptora'])}, {clean_sql_str(mov['responsable_entrega'])}, "
        f"{clean_sql_str(mov['responsable_receptor'])}, {clean_sql_str(mov.get('nro_autorizacion'))}, {clean_sql_str(mov.get('condicion_fisica', 'Buena'))}, "
        f"{clean_sql_str(mov.get('motivo'))}, {clean_sql_str(mov.get('estatus_sigebi', 'Aprobado'))}, {clean_sql_str(mov.get('observaciones'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert KPIs FO-017
seed_lines.append("\n-- 10. INSERTAR TABLERO DE 9 KPIS DEL SGA (FO-017)")
for k in data.get('kpis_sga_fo017', []):
    seed_lines.append(
        f"INSERT INTO desempeno_sga_fo017 (numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto) "
        f"VALUES ({k['numero']}, {clean_sql_str(k['indicador'])}, {clean_sql_str(k['dimension'])}, {clean_sql_str(k['formula'])}, "
        f"{clean_sql_str(k['meta'])}, {clean_sql_str(k['frecuencia'])}, {clean_sql_str(k['responsable'])}, {clean_sql_num(k.get('valor_real_q3'))}, "
        f"{clean_sql_str(k.get('valor_real_texto'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Acuerdos FO-019
seed_lines.append("\n-- 11. INSERTAR ACUERDOS DE REVISIÓN DIRECTIVA (FO-019)")
for ac in data.get('acuerdos_fo019', []):
    seed_lines.append(
        f"INSERT INTO acuerdos_direccion_fo019 (codigo, requisito_iso, acuerdo_adoptado, responsable, fecha_limite, recursos_aprobados, mecanismo_verificacion) "
        f"VALUES ({clean_sql_str(ac['codigo'])}, {clean_sql_str(ac['requisito_iso'])}, {clean_sql_str(ac['acuerdo_adoptado'])}, "
        f"{clean_sql_str(ac['responsable'])}, {clean_sql_str(ac.get('fecha_limite'))}, {clean_sql_str(ac.get('recursos_aprobados'))}, "
        f"{clean_sql_str(ac.get('mecanismo_verificacion'))}) "
        f"ON CONFLICT DO NOTHING;"
    )

# Insert Brechas FO-030
seed_lines.append("\n-- 12. INSERTAR PLAN DE CIERRE DE BRECHAS (FO-030)")
for b in data.get('brechas_fo030', []):
    seed_lines.append(
        f"INSERT INTO cierre_brechas_fo030 (numero, cod_brecha, origen_brecha, clausula_iso, laboratorio, descripcion, tipo_accion, causa_raiz_5p) "
        f"VALUES ({b['numero']}, {clean_sql_str(b['cod_brecha'])}, {clean_sql_str(b['origen_brecha'])}, {clean_sql_str(b['clausula_iso'])}, "
        f"{clean_sql_str(b['laboratorio'])}, {clean_sql_str(b['descripcion'])}, {clean_sql_str(b['tipo_accion'])}, {clean_sql_str(b['causa_raiz_5p'])}) "
        f"ON CONFLICT DO NOTHING;"
    )

with open('supabase_upgrade_seed.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(seed_lines))

print('Generated supabase_upgrade_seed.sql')
