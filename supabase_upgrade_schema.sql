-- ==============================================================================
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
