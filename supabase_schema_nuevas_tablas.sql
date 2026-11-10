-- ==============================================================================
-- SIGAF INTEVEP • SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS
-- SCRIPT DDL: CREACIÓN Y ACTUALIZACIÓN DE TODAS LAS TABLAS EN SUPABASE
-- Normas: ISO 55001:2024 / PDVSA MM-02-01-01 / ISO 10012 / ISO 17025 / SUDEBIP
-- ==============================================================================

-- 1. EXTENSIONES BÁSICAS DE POSTGRESQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==============================================================================
-- 2. TABLA PRINCIPAL: ACTIVOS FÍSICOS (INVENTARIO MAESTRO)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS activos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    num NUMERIC,
    tag_pdvsa TEXT UNIQUE NOT NULL,
    codigo_sudebip TEXT,
    codigo_sap TEXT,
    nombre TEXT NOT NULL,
    marca TEXT,
    modelo TEXT,
    serial TEXT,
    laboratorio TEXT NOT NULL,
    criticidad_analista TEXT,
    tipo_equipo TEXT,
    pareto_20 BOOLEAN DEFAULT FALSE,
    estado_operativo TEXT DEFAULT 'Operativo',
    filial TEXT DEFAULT 'PDVSA INTEVEP S.A.',
    sede TEXT DEFAULT 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
    gerencia TEXT DEFAULT 'Gerencia de Ambiente',
    sistema TEXT,
    custodio TEXT,
    etapa_ciclo_vida TEXT DEFAULT 'Operación y Mantenimiento',
    fecha_puesta_servicio DATE,
    numero_etiqueta_qr TEXT,
    condicion_fisica TEXT DEFAULT 'Buena',
    costo_adquisicion_usd NUMERIC DEFAULT 0,
    clasificacion_sudebip TEXT DEFAULT 'Equipos Científicos y de Laboratorio (Cat. 2.04.02)',
    unidad_administradora TEXT DEFAULT 'Gerencia de Ambiente - INTEVEP',
    responsable_patrimonial TEXT,
    rango_medicion TEXT,
    limite_deteccion TEXT,
    mep TEXT,
    condiciones_ambientales TEXT DEFAULT 'Temp: 20 ± 2 °C / HR: 45 - 60%',
    suministro_electrico TEXT DEFAULT '110/220 VAC - 60 Hz Regulada',
    frecuencia_calibracion TEXT DEFAULT 'Anual',
    estrategia_mantenimiento TEXT DEFAULT 'Preventivo Planificado Sistemático y Predictivo',
    frecuencia_mantenimiento TEXT DEFAULT 'Trimestral',
    proveedor_tecnico TEXT DEFAULT 'Taller Mantenimiento Instrumental INTEVEP',
    categoria_criticidad TEXT,
    ic NUMERIC,
    iobs NUMERIC,
    estatus_obsolescencia TEXT,
    nivel_riesgo NUMERIC,
    clasificacion_riesgo TEXT,
    nivel_oportunidad NUMERIC,
    prioridad_oportunidad TEXT,
    resultado_cruce TEXT,
    decision_estrategica TEXT,
    responsable_de TEXT,
    fecha_de DATE,
    decision_operativa TEXT,
    responsable_do TEXT,
    fecha_do DATE,
    jerarquizacion JSONB,
    obsolescencia JSONB,
    decision JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Si la tabla activos ya existía con menos campos, aseguramos que se agreguen las columnas:
ALTER TABLE activos 
  ADD COLUMN IF NOT EXISTS filial TEXT DEFAULT 'PDVSA INTEVEP S.A.',
  ADD COLUMN IF NOT EXISTS sede TEXT DEFAULT 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
  ADD COLUMN IF NOT EXISTS gerencia TEXT DEFAULT 'Gerencia de Ambiente',
  ADD COLUMN IF NOT EXISTS sistema TEXT,
  ADD COLUMN IF NOT EXISTS custodio TEXT,
  ADD COLUMN IF NOT EXISTS etapa_ciclo_vida TEXT DEFAULT 'Operación y Mantenimiento',
  ADD COLUMN IF NOT EXISTS fecha_puesta_servicio DATE,
  ADD COLUMN IF NOT EXISTS numero_etiqueta_qr TEXT,
  ADD COLUMN IF NOT EXISTS condicion_fisica TEXT DEFAULT 'Buena',
  ADD COLUMN IF NOT EXISTS costo_adquisicion_usd NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS clasificacion_sudebip TEXT DEFAULT 'Equipos Científicos y de Laboratorio (Cat. 2.04.02)',
  ADD COLUMN IF NOT EXISTS unidad_administradora TEXT DEFAULT 'Gerencia de Ambiente - INTEVEP',
  ADD COLUMN IF NOT EXISTS responsable_patrimonial TEXT,
  ADD COLUMN IF NOT EXISTS rango_medicion TEXT,
  ADD COLUMN IF NOT EXISTS limite_deteccion TEXT,
  ADD COLUMN IF NOT EXISTS mep TEXT,
  ADD COLUMN IF NOT EXISTS condiciones_ambientales TEXT DEFAULT 'Temp: 20 ± 2 °C / HR: 45 - 60%',
  ADD COLUMN IF NOT EXISTS suministro_electrico TEXT DEFAULT '110/220 VAC - 60 Hz Regulada',
  ADD COLUMN IF NOT EXISTS frecuencia_calibracion TEXT DEFAULT 'Anual',
  ADD COLUMN IF NOT EXISTS estrategia_mantenimiento TEXT DEFAULT 'Preventivo Planificado Sistemático y Predictivo',
  ADD COLUMN IF NOT EXISTS frecuencia_mantenimiento TEXT DEFAULT 'Trimestral',
  ADD COLUMN IF NOT EXISTS proveedor_tecnico TEXT DEFAULT 'Taller Mantenimiento Instrumental INTEVEP',
  ADD COLUMN IF NOT EXISTS categoria_criticidad TEXT,
  ADD COLUMN IF NOT EXISTS ic NUMERIC,
  ADD COLUMN IF NOT EXISTS iobs NUMERIC,
  ADD COLUMN IF NOT EXISTS estatus_obsolescencia TEXT,
  ADD COLUMN IF NOT EXISTS nivel_riesgo NUMERIC,
  ADD COLUMN IF NOT EXISTS clasificacion_riesgo TEXT,
  ADD COLUMN IF NOT EXISTS nivel_oportunidad NUMERIC,
  ADD COLUMN IF NOT EXISTS prioridad_oportunidad TEXT,
  ADD COLUMN IF NOT EXISTS resultado_cruce TEXT,
  ADD COLUMN IF NOT EXISTS decision_estrategica TEXT,
  ADD COLUMN IF NOT EXISTS responsable_de TEXT,
  ADD COLUMN IF NOT EXISTS fecha_de DATE,
  ADD COLUMN IF NOT EXISTS decision_operativa TEXT,
  ADD COLUMN IF NOT EXISTS responsable_do TEXT,
  ADD COLUMN IF NOT EXISTS fecha_do DATE,
  ADD COLUMN IF NOT EXISTS jerarquizacion JSONB,
  ADD COLUMN IF NOT EXISTS obsolescencia JSONB,
  ADD COLUMN IF NOT EXISTS decision JSONB;

-- ==============================================================================
-- 3. TABLA: CATÁLOGO OFICIAL SUDEBIP / BIENES PÚBLICOS
-- ==============================================================================
CREATE TABLE IF NOT EXISTS catalogo_sudebip (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT UNIQUE NOT NULL,
    tipo_equipo TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 4. TABLA: JERARQUIZACIÓN DE CRITICIDAD (PDVSA MM-02-01-01)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS jerarquizacion_criticidad (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    ff NUMERIC,          -- Frecuencia de Falla (1-4)
    io NUMERIC,          -- Impacto Operacional (1-10)
    fo NUMERIC,          -- Flexibilidad Operacional (1-4)
    cm NUMERIC,          -- Costo Mantenimiento (1-3)
    sha NUMERIC,         -- Seguridad, Higiene y Ambiente (1-8)
    consecuencia NUMERIC,-- Consecuencia = (IO x FO) + CM + SHA
    ic NUMERIC,          -- Índice de Criticidad = FF x Consecuencia
    categoria_criticidad TEXT, -- Nivel A, B o C
    estatus_seleccion TEXT,
    criterio_accion TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 5. TABLA: DETERMINACIÓN DE OBSOLESCENCIA PONDERADA (Iobs - ISO 55001)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS evaluacion_obsolescencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    eol NUMERIC,         -- Fin de Soporte del Fabricante (1-3)
    rep NUMERIC,         -- Disponibilidad de Repuestos (1-3)
    met NUMERIC,         -- Conformidad Metrológica (1-3)
    ant NUMERIC,         -- Antigüedad de Vida Útil (1-3)
    suma_puntos NUMERIC, -- Máximo 12 puntos
    iobs NUMERIC,        -- Iobs (%) = [(EOL+REP+MET+ANT)/12] x 100%
    estatus_obsolescencia TEXT, -- Crítica, Media, Baja
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 6. TABLA: EVALUACIÓN DE RIESGOS Y OPORTUNIDADES
-- ==============================================================================
CREATE TABLE IF NOT EXISTS evaluacion_riesgos_oportunidades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    categoria_aca TEXT,
    iobs NUMERIC,
    nivel_riesgo NUMERIC,          -- NR = P x I
    clasificacion_riesgo TEXT,
    beneficio NUMERIC,
    viabilidad NUMERIC,
    nivel_oportunidad NUMERIC,     -- NO = B x V
    prioridad_oportunidad TEXT,
    decision_sugerida TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 7. TABLA: CONSOLIDACIÓN DE DECISIONES ESTRATÉGICAS (MATRIZ DE CRUCE SAMP)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS decisiones_estrategicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    nivel_riesgo NUMERIC,
    clasificacion_riesgo TEXT,
    nivel_oportunidad NUMERIC,
    prioridad_oportunidad TEXT,
    resultado_cruce TEXT,          -- CRÍTICO EXTREMO, ALTO RIESGO, OBSOLESCENCIA ALTA, etc.
    decision_sugerida_riesgo TEXT,
    decision_sugerida_oportunidad TEXT,
    decision_estrategica_final TEXT, -- Decisión Estratégica (DE)
    responsable_de TEXT,
    fecha_estimada_de DATE,
    decision_operativa TEXT,        -- Decisión Operativa (DO)
    responsable_do TEXT,
    fecha_estimada_do DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 8. TABLA: HISTORIAL DE CALIBRACIONES Y METROLOGÍA (ISO 10012 / ISO 17025)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS calibraciones_metrologicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_calibracion TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    nro_certificado TEXT NOT NULL,
    fecha_calibracion DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    dias_restantes INT,
    estatus_metrologico TEXT NOT NULL, -- VIGENTE, POR VENCER, VENCIDA
    entidad_acreditada TEXT NOT NULL,
    patron_utilizado TEXT,
    desviacion_observada TEXT,
    incertidumbre_u TEXT,
    mep_tolerancia TEXT,
    dictamen TEXT NOT NULL,            -- Conforme (Pasa), No Conforme, etc.
    precinto_colocado TEXT,
    metrologo_responsable TEXT,
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 9. TABLA: MANTENIMIENTO OPERATIVO Y ÓRDENES DE TRABAJO (PDVSA MM-02-01-01 / FO-008)
-- ==============================================================================
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
    responsable_ejecucion TEXT,
    impacto_ensayos_iso17025 TEXT,
    requiere_recalibracion BOOLEAN DEFAULT FALSE,
    estatus_ot TEXT NOT NULL,          -- Programado, En Proceso, Cerrada
    aprobado_por TEXT,
    proximo_mantenimiento DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 10. TABLA: COMPROBACIONES INTERMEDIAS (ISO/IEC 17025)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS comprobaciones_intermedias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nro_registro TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    fecha_comprobacion DATE NOT NULL,
    patron_verificacion TEXT NOT NULL,
    valor_nominal_patron NUMERIC,
    lectura_instrumento NUMERIC,
    desviacion_calculada NUMERIC,
    criterio_aceptacion_mep NUMERIC,
    dictamen_auto TEXT,
    analista_ejecutor TEXT,
    supervisor_validador TEXT,
    rotulado_operativo TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 11. TABLA: CONTROL DE DERIVA METROLÓGICA (FO-018)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS deriva_metrologica_fo018 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tag_pdvsa TEXT NOT NULL,
    magnitud TEXT NOT NULL,
    ltm_ppm NUMERIC NOT NULL,
    fecha_cal_base DATE,
    error_base NUMERIC,
    fecha_comprobacion_q3 DATE,
    error_q3 NUMERIC,
    deriva_calculada_ppm NUMERIC,
    consumo_ltm_pct NUMERIC,
    estatus_alerta TEXT,
    accion_requerida TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 12. TABLA: CONTROL PATRIMONIAL SUDEBIP Y DEPRECIACIÓN EN LÍNEA RECTA
-- ==============================================================================
CREATE TABLE IF NOT EXISTS depreciacion_patrimonial (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tag_pdvsa TEXT NOT NULL,
    nro_bien_publico TEXT,
    costo_adquisicion_usd NUMERIC,
    fecha_incorporacion DATE,
    tasa_salvamento NUMERIC,
    valor_residual_salvamento NUMERIC,
    base_depreciable_usd NUMERIC,
    vida_util_anos INT,
    meses_uso INT,
    depreciacion_mensual_usd NUMERIC,
    depreciacion_acumulada_usd NUMERIC,
    valor_neto_libros_usd NUMERIC,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 13. TABLA: ACTAS DE MOVIMIENTO DE BIENES SUDEBIP (LOBP)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS actas_movimiento_sudebip (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nro_acta TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    fecha_movimiento DATE NOT NULL,
    tipo_movimiento TEXT NOT NULL, -- Traslado, Desincorporación, Asignación, etc.
    unidad_emisora TEXT NOT NULL,
    unidad_receptora TEXT NOT NULL,
    responsable_entrega TEXT NOT NULL,
    responsable_receptor TEXT NOT NULL,
    nro_autorizacion TEXT,
    condicion_fisica TEXT,
    motivo TEXT,
    estatus_sigebi TEXT DEFAULT 'Aprobado y Registrado',
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 14. TABLA: TABLERO DE CONTROL DE INDICADORES SGA (FO-017)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS kpis_sga_fo017 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero INT NOT NULL,
    indicador TEXT NOT NULL,
    dimension TEXT NOT NULL,
    formula TEXT,
    meta TEXT,
    frecuencia TEXT,
    responsable TEXT,
    valor_real_q3 NUMERIC,
    valor_real_texto TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 15. TABLA: ACUERDOS DE REVISIÓN POR LA DIRECCIÓN (FO-019)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS acuerdos_direccion_fo019 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT UNIQUE NOT NULL,
    requisito_iso TEXT NOT NULL,
    acuerdo_adoptado TEXT NOT NULL,
    responsable TEXT NOT NULL,
    fecha_limite DATE,
    recursos_aprobados TEXT,
    mecanismo_verificacion TEXT,
    estatus TEXT DEFAULT 'En Ejecución',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 16. TABLA: PLANES DE CIERRE DE BRECHAS Y NO CONFORMIDADES (FO-030)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS cierre_brechas_fo030 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero INT NOT NULL,
    cod_brecha TEXT UNIQUE NOT NULL,
    origen_brecha TEXT NOT NULL,
    clausula_iso TEXT NOT NULL,
    laboratorio TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    tipo_accion TEXT NOT NULL,
    causa_raiz_5p TEXT,
    estatus TEXT DEFAULT 'En Proceso',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 17. TABLA: HISTORIAL DE FALLAS (FO-004)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS fallas_historial (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    fecha_evento DATE NOT NULL,
    tipo_evento TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    tiempo_fuera_servicio_horas NUMERIC DEFAULT 0,
    impacto_operacional TEXT,
    accion_tomada TEXT,
    tecnico_responsable TEXT,
    costo_reparacion NUMERIC DEFAULT 0,
    estado TEXT DEFAULT 'Completado',
    prioridad TEXT DEFAULT 'Media',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==============================================================================
-- 18. TABLA: BITÁCORA DE CAMBIOS Y AUDITORÍA
-- ==============================================================================
CREATE TABLE IF NOT EXISTS bitacora_cambios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    fecha_cambio TIMESTAMPTZ DEFAULT NOW(),
    usuario TEXT NOT NULL,
    accion TEXT NOT NULL,
    detalle TEXT NOT NULL
);

-- ==============================================================================
-- 19. TABLA: USUARIOS Y ROLES DEL SISTEMA (LOGIN RBAC)
-- ==============================================================================
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

-- ==============================================================================
-- 20. TABLA: CATÁLOGOS DINÁMICOS DE PARÁMETROS (SELECTS EDITABLES)
-- ==============================================================================
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

-- ==============================================================================
-- 21. ÍNDICES DE RENDIMIENTO PARA BÚSQUEDAS RÁPIDAS
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_activos_tag_pdvsa ON activos(tag_pdvsa);
CREATE INDEX IF NOT EXISTS idx_activos_codigo_sudebip ON activos(codigo_sudebip);
CREATE INDEX IF NOT EXISTS idx_activos_laboratorio ON activos(laboratorio);
CREATE INDEX IF NOT EXISTS idx_activos_pareto ON activos(pareto_20);
CREATE INDEX IF NOT EXISTS idx_activos_criticidad ON activos(categoria_criticidad);
CREATE INDEX IF NOT EXISTS idx_calibraciones_tag ON calibraciones_metrologicas(tag_pdvsa);
CREATE INDEX IF NOT EXISTS idx_mantenimientos_tag ON mantenimientos_pdvsa(tag_pdvsa);
CREATE INDEX IF NOT EXISTS idx_comprobaciones_tag ON comprobaciones_intermedias(tag_pdvsa);
CREATE INDEX IF NOT EXISTS idx_deriva_tag ON deriva_metrologica_fo018(tag_pdvsa);
CREATE INDEX IF NOT EXISTS idx_deprec_tag ON depreciacion_patrimonial(tag_pdvsa);

-- ==============================================================================
-- 22. POLÍTICAS DE ACCESO PÚBLICO / ANÓNIMO PARA SUPABASE CLIENT
-- ==============================================================================
ALTER TABLE activos ENABLE ROW LEVEL SECURITY;
ALTER TABLE catalogo_sudebip ENABLE ROW LEVEL SECURITY;
ALTER TABLE jerarquizacion_criticidad ENABLE ROW LEVEL SECURITY;
ALTER TABLE evaluacion_obsolescencia ENABLE ROW LEVEL SECURITY;
ALTER TABLE decisiones_estrategicas ENABLE ROW LEVEL SECURITY;
ALTER TABLE calibraciones_metrologicas ENABLE ROW LEVEL SECURITY;
ALTER TABLE mantenimientos_pdvsa ENABLE ROW LEVEL SECURITY;
ALTER TABLE comprobaciones_intermedias ENABLE ROW LEVEL SECURITY;
ALTER TABLE deriva_metrologica_fo018 ENABLE ROW LEVEL SECURITY;
ALTER TABLE depreciacion_patrimonial ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpis_sga_fo017 ENABLE ROW LEVEL SECURITY;
ALTER TABLE acuerdos_direccion_fo019 ENABLE ROW LEVEL SECURITY;
ALTER TABLE cierre_brechas_fo030 ENABLE ROW LEVEL SECURITY;
ALTER TABLE fallas_historial ENABLE ROW LEVEL SECURITY;
ALTER TABLE bitacora_cambios ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios_sistema ENABLE ROW LEVEL SECURITY;
ALTER TABLE catalogos_parametros ENABLE ROW LEVEL SECURITY;

-- Políticas de lectura abierta para el SGA:
DROP POLICY IF EXISTS "Permitir lectura publica de activos" ON activos;
CREATE POLICY "Permitir lectura publica de activos" ON activos FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir insercion/actualizacion de activos" ON activos;
CREATE POLICY "Permitir insercion/actualizacion de activos" ON activos FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura catalogo sudebip" ON catalogo_sudebip;
CREATE POLICY "Permitir lectura catalogo sudebip" ON catalogo_sudebip FOR SELECT USING (true);

DROP POLICY IF EXISTS "Permitir lectura calibraciones" ON calibraciones_metrologicas;
CREATE POLICY "Permitir lectura calibraciones" ON calibraciones_metrologicas FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura mantenimientos" ON mantenimientos_pdvsa;
CREATE POLICY "Permitir lectura mantenimientos" ON mantenimientos_pdvsa FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura comprobaciones" ON comprobaciones_intermedias;
CREATE POLICY "Permitir lectura comprobaciones" ON comprobaciones_intermedias FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura deriva" ON deriva_metrologica_fo018;
CREATE POLICY "Permitir lectura deriva" ON deriva_metrologica_fo018 FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura depreciacion" ON depreciacion_patrimonial;
CREATE POLICY "Permitir lectura depreciacion" ON depreciacion_patrimonial FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura kpis" ON kpis_sga_fo017;
CREATE POLICY "Permitir lectura kpis" ON kpis_sga_fo017 FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura usuarios" ON usuarios_sistema;
CREATE POLICY "Permitir lectura usuarios" ON usuarios_sistema FOR ALL USING (true);

DROP POLICY IF EXISTS "Permitir lectura catalogos" ON catalogos_parametros;
CREATE POLICY "Permitir lectura catalogos" ON catalogos_parametros FOR ALL USING (true);

-- Confirmación de ejecución exitosa
SELECT 'ESTRUCTURA DE TABLAS CREADA Y ACTUALIZADA EXITOSAMENTE' AS resultado;
