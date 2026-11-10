-- ==============================================================================
-- SIGAF INTEVEP • SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS
-- IMPORTACIÓN DE DATA 100% REAL DE LA HERRAMIENTA OFICIAL SGA
-- Fuente: herramienta_sga.xlsx / hoja_de_vida_integral.xlsx / formularios_anexos_sga.xlsx
-- ==============================================================================

-- 1. ASEGURAR EXTENSIÓN UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. ASEGURAR COLUMNAS EN TABLA ACTIVOS
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
    laboratorio TEXT,
    criticidad_analista TEXT,
    tipo_equipo TEXT,
    pareto_20 BOOLEAN DEFAULT FALSE,
    estado_operativo TEXT DEFAULT 'Operativo',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

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

-- 3. TABLAS DE RELACIONES
CREATE TABLE IF NOT EXISTS catalogo_sudebip (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT UNIQUE NOT NULL,
    tipo_equipo TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS jerarquizacion_criticidad (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    ff NUMERIC,
    io NUMERIC,
    fo NUMERIC,
    cm NUMERIC,
    sha NUMERIC,
    consecuencia NUMERIC,
    ic NUMERIC,
    categoria_criticidad TEXT,
    estatus_seleccion TEXT,
    criterio_accion TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS evaluacion_obsolescencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    eol NUMERIC,
    rep NUMERIC,
    met NUMERIC,
    ant NUMERIC,
    suma_puntos NUMERIC,
    iobs NUMERIC,
    estatus_obsolescencia TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS decisiones_estrategicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    nivel_riesgo NUMERIC,
    clasificacion_riesgo TEXT,
    nivel_oportunidad NUMERIC,
    prioridad_oportunidad TEXT,
    resultado_cruce TEXT,
    decision_sugerida_riesgo TEXT,
    decision_sugerida_oportunidad TEXT,
    decision_estrategica_final TEXT,
    responsable_de TEXT,
    fecha_estimada_de DATE,
    decision_operativa TEXT,
    responsable_do TEXT,
    fecha_estimada_do DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

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
    dictamen TEXT,
    precinto_colocado TEXT,
    metrologo_responsable TEXT,
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

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
    estatus_ot TEXT NOT NULL,
    aprobado_por TEXT,
    proximo_mantenimiento DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

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

CREATE TABLE IF NOT EXISTS usuarios_sistema (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre_completo TEXT NOT NULL,
    rol TEXT NOT NULL,
    cargo TEXT,
    laboratorio TEXT,
    clave_demo TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS catalogos_parametros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria TEXT NOT NULL,
    codigo TEXT NOT NULL,
    nombre TEXT NOT NULL,
    orden INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE
);

-- ==============================================================================
-- 4. LIMPIEZA PREVIA DE TABLAS (VACÍA REGISTROS OBSOLETOS/PRUEBA)
-- ==============================================================================
TRUNCATE TABLE comprobaciones_intermedias, mantenimientos_pdvsa, calibraciones_metrologicas, deriva_metrologica_fo018, depreciacion_patrimonial, kpis_sga_fo017, jerarquizacion_criticidad, evaluacion_obsolescencia, decisiones_estrategicas CASCADE;
TRUNCATE TABLE activos CASCADE;
TRUNCATE TABLE catalogo_sudebip CASCADE;
TRUNCATE TABLE catalogos_parametros CASCADE;
TRUNCATE TABLE usuarios_sistema CASCADE;

-- ==============================================================================
-- 5. INSERTAR CATÁLOGO SUDEBIP (228 CÓDIGOS OFICIALES)
-- ==============================================================================

INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0001', 'Agitadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0002', 'Alambiques') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0003', 'Alcalímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0004', 'Alcoholmetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0005', 'Altímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0006', 'Altoparlantes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0007', 'Amperímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0008', 'Ampliadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0009', 'Analizadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0010', 'Anemógrafos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0011', 'Anemómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0012', 'Aneroides (ver barómetros)') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0013', 'Aparatos de explotación geográ') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0014', 'Aparatos de reducción kjeldahl') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0015', 'Aparatos de reducción catalíti') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0016', 'Aparatos para colorear') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0017', 'Aparatos para destilar agua') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0018', 'Aparatos para electrólisis') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0019', 'Aparatos para interpretación d') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0020', 'Aparatos para la indeterminaci') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0021', 'Aparatos para pruebas de sedim') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0022', 'Arcos voltaicos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0023', 'Areómetros (ver densímetros)') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0024', 'Autoclaves') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0025', 'Balanzas de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0026', 'Bancos ópticos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0027', 'Baños de maría (no de uso clín') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0028', 'Baños para impregnación de par') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0029', 'Barómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0030', 'Binóculos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0031', 'Biofotocolorímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0032', 'Bombas de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0033', 'Brújulas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0034', 'Caleidoscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0035', 'Calorímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0036', 'Cámaras microfotográficas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0037', 'Cámaras de recuento') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0038', 'Cámaras lúcidas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0039', 'Cámaras fotográficas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0040', 'Catetómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0041', 'Carretes de ruhmkorff') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0042', 'Centrifugadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0043', 'Centrífugas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0044', 'Círculos meridianos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0045', 'Clicimetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0046', 'Colorímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0047', 'Condensadores de campo oscuro') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0048', 'Contadores de rayos ionizados') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0049', 'Contadores geiger') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0050', 'Convertidores microfotográfico') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0051', 'Copiadores fotográficos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0052', 'Cronómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0053', 'Cubetas esmaltadas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0054', 'Cuentahílos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0055', 'Densímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0056', 'Desecadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0057', 'Deshumecedores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0058', 'Destiladores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0059', 'Detectores de minas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0060', 'Determinadores del carbono') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0061', 'Dializadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0062', 'Dicroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0063', 'Digestorios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0064', 'Dinamómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0065', 'Dispensadores de placas de vid') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0066', 'Eclímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0067', 'Editoras para películas fotogr') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0068', 'Electroanalizadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0069', 'Electrodos de platino') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0070', 'Electróforos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0071', 'Electrografos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0072', 'Electroimanes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0073', 'Electrómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0074', 'Electrópodos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0075', 'Electroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0076', 'Eliminadores de batería') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0077', 'Empacadoras de píldoras') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0078', 'Emulsificadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0079', 'Equipos de micro-combustión') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0080', 'Equipos de telemetración') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0081', 'Equipos de tratamiento al calo') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0082', 'Equipos fotoeléctricos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0083', 'Escleroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0084', 'Escurridores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0085', 'Esferómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0086', 'Espectrofotómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0087', 'Espectroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0088', 'Estereómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0089', 'Estereoscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0090', 'Estroboscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0091', 'Estuches para accesorios fotog') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0092', 'Estufas de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0093', 'Eudiómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0094', 'Evaporímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0095', 'Extractores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0096', 'Filmadoras') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0097', 'Filtros de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0098', 'Flash fotográficos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0099', 'Flexómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0100', 'Fluoroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0101', 'Fluxómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0102', 'Fotómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0103', 'Gabinetes de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0104', 'Gabinetes de fermentación') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0105', 'Galvanómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0106', 'Gavetas para láminas microscóp') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0107', 'Generadores de señales') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0108', 'Giroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0109', 'Goniómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0110', 'Grafómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0111', 'Gramurios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0112', 'Gravitómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0113', 'Guarada-láminas (ver laminotec') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0114', 'Heliografos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0115', 'Hemisferios de magdeburgo') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0116', 'Hidrogenadores catalíticos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0117', 'Higrómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0118', 'Higroscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0119', 'Hipsómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0120', 'Hornillos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0121', 'Hornos de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0122', 'Hornos prensa al vaco') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0123', 'Incubadoras de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0124', 'Indicadores del punto de fusió') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0125', 'Inductores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0126', 'Juegos de lentes en estuche') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0127', 'Juegos de pesas de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0128', 'Laboratorios químicos de campo') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0129', 'Laminotecas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0130', 'Lámparas infrarrojas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0131', 'Lámparas para microscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0133', 'Lámparas ultravioletas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0134', 'Largavistas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0135', 'Lavadoras de pipetas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0136', 'Lijadoras metalográficas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0137', 'Lupas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0138', 'Magnetómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0139', 'Magnetos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0140', 'Máquinas neumáticas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0141', 'Máquinas para supositorios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0142', 'Marcadores de películas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0143', 'Mecheros bunsen') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0144', 'Megáfonos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0145', 'Medidores de ácidos (ph)') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0146', 'Medidores de fluido') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0147', 'Mesas de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0148', 'Mezcladoras (laboratorio)') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0149', 'Microfilmadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0150', 'Microscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0151', 'Micrótomos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0152', 'Miras') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0153', 'Moldes para pruebas de compact') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0154', 'Moldes para supositorios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0155', 'Molinos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0156', 'Multímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0157', 'Morteros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0158', 'Muflas (ver hornos de laborato') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0159', 'Neveras de laboratorio') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0160', 'Niveles') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0161', 'Niveles de anteojo (amney)') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0162', 'Objetivos microscópicos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0163', 'Octantes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0164', 'Oculares') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0165', 'Ohmímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0166', 'Oscilógrafos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0167', 'Oscilómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0168', 'Osciloscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0169', 'Penetrómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0170', 'Perforadores de corchos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0171', 'Periscopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0172', 'Permeámetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0173', 'Pesahilos de precisión') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0174', 'Pipeteadores automáticos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0175', 'Pipeteros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0176', 'Pirómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0177', 'Planchetas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0178', 'Planímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0179', 'Pluviómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0180', 'Podómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0181', 'Polarímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0182', 'Polarizadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0183', 'Porta-láminas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0184', 'Potenciómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0185', 'Prensas metalográficas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0186', 'Probadores de humedad') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0187', 'Probadores de consistencia de') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0188', 'Probadores de ductibilidad') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0189', 'Probadores del punto de flash') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0190', 'Probadores de resistencias') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0191', 'Probadores de tubos electrónic') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0192', 'Puentes de wheatstone') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0193', 'Pulidoras metalográficas') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0194', 'Radiadores acústicos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0195', 'Radiadores de calor') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0196', 'Refractómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0197', 'Registradores fotoeléctricos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0198', 'Registradores minifn') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0199', 'Reglas de cálculo') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0200', 'Reguladores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0201', 'Reóstatos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0202', 'Sacarímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0203', 'Scintilómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0204', 'Secadores eléctricos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0205', 'Serpentines') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0206', 'Sextantes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0207', 'Sismógrafos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0208', 'Sitómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0209', 'Sonómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0210', 'Soportes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0211', 'Taquímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0212', 'Telémetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0213', 'Telescopios') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0214', 'Tensiómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0215', 'Teodolitos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0216', 'Termógrafos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0217', 'Termómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0218', 'Termostatos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0219', 'Torsiómetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0220', 'Tránsitos') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0221', 'Transportadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0222', 'Trazadores de señales') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0223', 'Trípodes') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0224', 'Trituradores -pulverizadores') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0225', 'Turbidmetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0226', 'Velocímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0227', 'Vescocimetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18010-0228', 'Voltímetros') ON CONFLICT (codigo) DO NOTHING;
INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ('18990-0000', 'Otros equipos científicos') ON CONFLICT (codigo) DO NOTHING;

-- 6. INSERTAR USUARIOS Y ROLES

INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ('usr-admin-01', 'admin@intevep.pdvsa.com', 'Ing. Carlos Mendoza (Admin)', 'admin', 'Líder de Calidad y Coordinador SGA', 'Gerencia de Ambiente (GAMB)', 'Admin*2026')
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;
INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ('usr-analista-01', 'analista@intevep.pdvsa.com', 'Lcdo. Miguel Arismendi', 'analista', 'Analista Especialista de Laboratorio', 'Aire (Calidad de Aire)', 'Analista*2026')
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;
INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ('usr-mant-01', 'mantenimiento@intevep.pdvsa.com', 'Ing. Klaus Weber', 'mantenimiento', 'Especialista en Mantenimiento Instrumental', 'Taller de Mantenimiento Especializado', 'Mant*2026')
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;
INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ('usr-sudebip-01', 'sudebip@intevep.pdvsa.com', 'Lcda. Elena Rodríguez', 'sudebip', 'Custodio Patrimonial de Bienes Públicos', 'Gerencia de Finanzas y Control de Bienes', 'Sudebip*2026')
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;
INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ('usr-gerente-01', 'gerente@intevep.pdvsa.com', 'Dra. Rebeca Salazar', 'gerente', 'Gerente de Ambiente INTEVEP', 'Gerencia de Ambiente (GAMB)', 'Gerente*2026')
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;

-- 7. INSERTAR CATÁLOGOS DINÁMICOS

INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-01', 'Aire (Calidad de Aire)', 1);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-02', 'Efluentes (Tratabilidad de Efluentes)', 2);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-03', 'Biotecnología', 3);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-04', 'Ecotoxicología', 4);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-05', 'Química Ambiental', 5);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-06', 'Desechos ( Tratabilidad de Desechos)', 6);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('laboratorios', 'labo-07', 'Gerencia de Ambiente', 7);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('estados_operativos', 'esta-01', 'Operativo', 1);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('estados_operativos', 'esta-02', 'En Calibración', 2);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('estados_operativos', 'esta-03', 'En Mantenimiento', 3);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('estados_operativos', 'esta-04', 'Fuera de Servicio', 4);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('estados_operativos', 'esta-05', 'Desincorporado', 5);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('clasificaciones_funcionales', 'clas-01', 'Instrumento de Medición', 1);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('clasificaciones_funcionales', 'clas-02', 'Equipo de Ensayo y Análisis', 2);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('clasificaciones_funcionales', 'clas-03', 'Equipo Auxiliar de Laboratorio', 3);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('clasificaciones_funcionales', 'clas-04', 'Equipo de Muestreo de Campo', 4);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('clasificaciones_funcionales', 'clas-05', 'Sistema de Tratamiento', 5);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('frecuencias_mantenimiento', 'frec-01', 'Mensual', 1);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('frecuencias_mantenimiento', 'frec-02', 'Bimestral', 2);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('frecuencias_mantenimiento', 'frec-03', 'Trimestral', 3);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('frecuencias_mantenimiento', 'frec-04', 'Semestral', 4);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('frecuencias_mantenimiento', 'frec-05', 'Anual', 5);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-01', 'ISO 55001:2024', 1);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-02', 'PDVSA MM-02-01-01', 2);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-03', 'ISO 10012:2003', 3);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-04', 'ISO/IEC 17025:2017', 4);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-05', 'SUDEBIP/LOBP', 5);
INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ('normas_tecnicas', 'norm-06', 'LOPCYMAT', 6);

-- 8. INSERTAR 334 ACTIVOS REALES DE HERRAMIENTA SGA

DO $$
DECLARE
    v_act_id UUID;
BEGIN

    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        1, 'INT-GAMB-AIRE-ANA01', '18010-0009-1', '199711198',
        'ANALIZADOR DE O3', 'THERMO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        2, 'INT-GAMB-AIRE-ANA02', '18010-0009-2', '199711272',
        'ANALIZADOR DE O3', 'THERMO', '49C', '49C-59563323',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 75.0, 83.33,
        'Obsolescencia Crítica', 2.0, 'Riesgo Bajo',
        6.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA',
        'Inclusión en Plan de Renovación Tecnológica', 'Responsable de Laboratorio', '2027-08-01',
        'Mantenimiento Estándar Correr a la Falla (Run-to-Failure)', 'Analista de Gestióon de Calidad', '2026-10-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA02", "nombre": "ANALIZADOR DE O3", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 25.0, "ic": 75.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA02", "nombre": "ANALIZADOR DE O3", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "OBSOLESCENCIA ALTA", "decision_sugerida_riesgo": "Reemplazo Planificado a Mediano Plazo", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "Inclusión en Plan de Renovación Tecnológica", "responsable_de": "Responsable de Laboratorio", "fecha_de": "2027-08-01", "decision_operativa": "Mantenimiento Estándar Correr a la Falla (Run-to-Failure)", "responsable_do": "Analista de Gestióon de Calidad", "fecha_do": "2026-10-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 3.0, 10.0, 2.0, 1.0, 4.0, 25.0, 75.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 2.0, 'Riesgo Bajo', 6.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA', 'Reemplazo Planificado a Mediano Plazo', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', 'Inclusión en Plan de Renovación Tecnológica', 'Responsable de Laboratorio', '2027-08-01', 'Mantenimiento Estándar Correr a la Falla (Run-to-Failure)', 'Analista de Gestióon de Calidad', '2026-10-10');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        3, 'INT-GAMB-AIRE-ANA03', '18010-0009-3', '199700011',
        'ANALIZADOR DE O3', 'THERMO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        4, 'INT-GAMB-AIRE-AIR04', '18990-0000-4', '20120109',
        'AIRE ZERO', 'INNOTEC', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        5, 'INT-GAMB-AIRE-AUT05', '18990-0000-5', '199712647',
        'Autosampler Canisters', 'Entech', '7016', '2156634',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        6, 'INT-GAMB-AIRE-ANA06', '18010-0009-6', '200200712',
        'ANALIZADOR DE CO', 'horiba', 'Sin Información', '42890430012',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        7, 'INT-GAMB-AIRE-ANA07', '18010-0009-7', '199711281',
        'ANALIZADOR DE CO', 'HORIBA', 'Sin Información', '159454',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        8, 'INT-GAMB-AIRE-ANA08', '18010-0009-8', '199712973',
        'ANALIZADOR DE CO', 'THERMO', 'Sin Información', '110001-438',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        9, 'INT-GAMB-AIRE-ANA09', '18010-0009-9', '199800013',
        'ANALIZADOR DE CO', 'THERMO', 'Sin Información', 'M9000403',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        10, 'INT-GAMB-AIRE-BET10', '18990-0000-10', '199713277',
        'BETA GAUS', 'TERMO', 'Sin Información', '665',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        11, 'INT-GAMB-AIRE-ANA11', '18010-0009-11', '199713208',
        'ANALIZADOR DE CO', 'MONITOR LAB', 'Sin Información', '214803',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        12, 'INT-GAMB-AIRE-BET12', '18990-0000-12', '199713276',
        'BETA GAUS', 'TERMO', 'Sin Información', '85332-241',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        13, 'INT-GAMB-AIRE-ANA13', '18010-0009-13', '199711220',
        'ANALIZADOR DE CO', 'MONITOR LAB', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        14, 'INT-GAMB-AIRE-CAL14', '18990-0000-14', '199711184',
        'Calibrador Primario', 'GRASEBY', 'Sin Información', 'PTS23032009',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        15, 'INT-GAMB-AIRE-CAL15', '18990-0000-15', '199711172',
        'CALIBRADOR PRIMARIO DE O3', 'TERMO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Patrón de Medida',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        16, 'INT-GAMB-AIRE-CAN16', '18990-0000-16', '199713200',
        'Canister de Acero Inoxidable', 'Graseby', 'AP27106', 'Sin Información',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        17, 'INT-GAMB-AIRE-CAR17', '18990-0000-17', 'Sin Información',
        'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        18, 'INT-GAMB-AIRE-ANA18', '18010-0009-18', '199711283',
        'ANALIZADOR DE H2S', 'horiba', 'Sin Información', '57690901',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 36.0, 83.33,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', '2026-11-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA18", "nombre": "ANALIZADOR DE H2S", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 12.0, "ic": 36.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos y oportunidades; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA18", "nombre": "ANALIZADOR DE H2S", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2026-11-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA18', 3.0, 5.0, 2.0, 1.0, 1.0, 12.0, 36.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos y oportunidades; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA18', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        19, 'INT-GAMB-AIRE-CAR19', '18990-0000-19', 'Sin Información',
        'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        20, 'INT-GAMB-AIRE-ANA20', '18010-0009-20', '199800014',
        'ANALIZADOR DE HC', 'THERMO', '55C', '55C60839328',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 86.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2026-12-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA20", "nombre": "ANALIZADOR DE HC", "laboratorio": "Aire (Calidad de Aire)", "ff": 2.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 86.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA20", "nombre": "ANALIZADOR DE HC", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2026-12-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA20', 2.0, 10.0, 4.0, 2.0, 1.0, 43.0, 86.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA20', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        21, 'INT-GAMB-AIRE-CAR21', '18990-0000-21', 'Sin Información',
        'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        22, 'INT-GAMB-AIRE-CAR22', '18990-0000-22', 'Sin Información',
        'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información',
        'Aire (Calidad de Aire)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        23, 'INT-GAMB-AIRE-COM23', '18990-0000-23', '199711179',
        'COMPRESOR', 'SIEMENS', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        24, 'INT-GAMB-AIRE-COM24', '18990-0000-24', '199711211',
        'COMPUTADORA', 'HP', 'Sin Información', '651728',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        25, 'INT-GAMB-AIRE-COM25', '18990-0000-25', '7001359',
        'computadora', 'HP', 'Compac', 'Sin Información',
        'Aire (Calidad de Aire)', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        26, 'INT-GAMB-AIRE-CON26', '18990-0000-26', '200200623',
        'CONSOLA METEOROLOGIA', 'YOUNG', 'Sin Información', 'PT05937',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 60.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        1.0, 'Mejora Continua Menor', '',
        '', '', NULL,
        '', '', '2027-01-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-CON26", "nombre": "CONSOLA METEOROLOGIA", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 2.0, "sha": 8.0, "consecuencia": 20.0, "ic": 60.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-CON26", "nombre": "CONSOLA METEOROLOGIA", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "Mejora Continua Menor", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-01-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON26', 3.0, 5.0, 2.0, 2.0, 8.0, 20.0, 60.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON26', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        27, 'INT-GAMB-AIRE-CON27', '18990-0000-27', '119713208',
        'CONVERTIDOR DE H2S', 'horiba', 'Sin Información', '575995022',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-02-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-CON27", "nombre": "CONVERTIDOR DE H2S", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-CON27", "nombre": "CONVERTIDOR DE H2S", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-02-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON27', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON27', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        28, 'INT-GAMB-AIRE-CON28', '18990-0000-28', '199713185',
        'CONVERTIDOR DE NH3', 'HORIBA', 'BM-1A', '575995031',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-03-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-CON28", "nombre": "CONVERTIDOR DE NH3", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-CON28", "nombre": "CONVERTIDOR DE NH3", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-03-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON28', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON28', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        29, 'INT-GAMB-AIRE-CON29', '18990-0000-29', '199711149',
        'CONVERTIDOR DE NH3', 'HORIBA', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        30, 'INT-GAMB-AIRE-DAT30', '18990-0000-30', '200100390',
        'DATA LOGGER', 'Sin Información', 'Sin Información', '4256',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 100.0, 83.33,
        'Obsolescencia Crítica', 5.25, 'Riesgo Medio',
        9.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA',
        '', '', NULL,
        '', '', '2027-04-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-DAT30", "nombre": "DATA LOGGER", "laboratorio": "Aire (Calidad de Aire)", "ff": 4.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 25.0, "ic": 100.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-DAT30", "nombre": "DATA LOGGER", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "OBSOLESCENCIA ALTA", "decision_sugerida_riesgo": "Reemplazo Planificado a Mediano Plazo", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-04-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DAT30', 4.0, 10.0, 2.0, 1.0, 4.0, 25.0, 100.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DAT30', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        31, 'INT-GAMB-AIRE-DES31', '18010-0057-31', 'Sin Información',
        'Deshumidificador de filtros 1', 'Sin Información', 'Sin Información', '5220',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        32, 'INT-GAMB-AIRE-DES32', '18010-0057-32', 'Sin Información',
        'Deshumidificador de filtros 2', 'Sin Información', 'Sin Información', '5218',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 46.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-05-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-DES32", "nombre": "Deshumidificador de filtros 2", "laboratorio": "Aire (Calidad de Aire)", "ff": 2.0, "io": 10.0, "fo": 2.0, "cm": 2.0, "sha": 1.0, "consecuencia": 23.0, "ic": 46.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-DES32", "nombre": "Deshumidificador de filtros 2", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-05-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES32', 2.0, 10.0, 2.0, 2.0, 1.0, 23.0, 46.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES32', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        33, 'INT-GAMB-AIRE-DES33', '18010-0057-33', '200600060',
        'Deshumidificador de sala 1', 'WHITESONIC', 'WSPMID-12CR', '1.055308770601E+17',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 46.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-06-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-DES33", "nombre": "Deshumidificador de sala 1", "laboratorio": "Aire (Calidad de Aire)", "ff": 2.0, "io": 10.0, "fo": 2.0, "cm": 2.0, "sha": 1.0, "consecuencia": 23.0, "ic": 46.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-DES33", "nombre": "Deshumidificador de sala 1", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-06-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES33', 2.0, 10.0, 2.0, 2.0, 1.0, 23.0, 46.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES33', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        34, 'INT-GAMB-AIRE-DES34', '18010-0057-34', '200600061',
        'Deshumidificador de sala 2', 'WHITESONIC', 'WSPMID-12CR', '1.055308770601E+16',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        35, 'INT-GAMB-AIRE-ANA35', '18010-0009-35', '199712970',
        'ANALIZADOR DE NH3', 'THERMO', '17C', '17C-61220330',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-07-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA35", "nombre": "ANALIZADOR DE NH3", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA35", "nombre": "ANALIZADOR DE NH3", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-07-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA35', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA35', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        36, 'INT-GAMB-AIRE-ANA36', '18010-0009-36', '199800015',
        'ANALIZADOR DE NH3', 'THERMO', '55C', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        37, 'INT-GAMB-AIRE-ANA37', '18010-0009-37', '199713190',
        'ANALIZADOR DE NO2', 'HORIBA', 'APNA-360', '574635092',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-08-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA37", "nombre": "ANALIZADOR DE NO2", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA37", "nombre": "ANALIZADOR DE NO2", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-08-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA37', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA37', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        38, 'INT-GAMB-AIRE-ANA38', '18010-0009-38', '199712975',
        'ANALIZADOR DE NO2', 'THERMO', 'Sin Información', 'K199 1227230442 P',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        39, 'INT-GAMB-AIRE-ANA39', '18010-0009-39', '199800012',
        'ANALIZADOR DE NO2', 'THERMO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        40, 'INT-GAMB-AIRE-ANA40', '18010-0009-40', '200601635',
        'ANALIZADOR DE NOX', 'teledine', 'Sin Información', '1671',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        41, 'INT-GAMB-AIRE-ANA41', '18010-0009-41', '199712977',
        'ANALIZADOR DE O3', 'THERMO', '49C', '49C-60817328',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        42, 'INT-GAMB-AIRE-ANA42', '18010-0009-42', '200603543',
        'ANALIZADOR DE OZONO', 'THERMO', 'Sin Información', '936539417',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        43, 'INT-GAMB-AIRE-EQU43', '18990-0000-43', '199800643',
        'EQUIPO PUFS', 'GRASEBY', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        44, 'INT-GAMB-AIRE-BOM44', '18010-0032-44', 'Sin Información',
        'BOMBA SUCCION THOMAS', 'Sin Información', 'Sin Información', '0701-00000591',
        'Aire (Calidad de Aire)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        45, 'INT-GAMB-AIRE-ANA45', '18010-0009-45', '200601647',
        'ANALIZADOR  HIDROCARBUROS', 'Sin Información', 'Sin Información', '43268760062',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        46, 'INT-GAMB-AIRE-ANA46', '18010-0009-46', '199800011',
        'ANALIZADOR DE OZONO', 'TERMO', 'Sin Información', '981118325',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        47, 'INT-GAMB-AIRE-ANA47', '18010-0009-47', '199713195',
        'ANALIZADOR DE SO2', 'horiba', 'Sin Información', '575995011',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-09-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA47", "nombre": "ANALIZADOR DE SO2", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA47", "nombre": "ANALIZADOR DE SO2", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-09-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA47', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA47', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        48, 'INT-GAMB-AIRE-ANA48', '18010-0009-48', '199713195',
        'ANALIZADOR DE SO2', 'HORIBA', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        49, 'INT-GAMB-AIRE-BOM49', '18010-0032-49', 'Sin Información',
        'BOMBA DE SUCCIÓN  KNF', 'Sin Información', 'Sin Información', '406722',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-10-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-BOM49", "nombre": "BOMBA DE SUCCIÓN  KNF", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-BOM49", "nombre": "BOMBA DE SUCCIÓN  KNF", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-10-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-BOM49', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-BOM49', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        50, 'INT-GAMB-AIRE-GAS50', '18990-0000-50', '199713739',
        'Gas Chromatograph', 'Sin Información', '5890', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        51, 'INT-GAMB-AIRE-GEN51', '18990-0000-51', '199800149',
        'GENERADOR DE H2', 'PACKARD', 'Sin Información', '191026841',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', '2027-11-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-GEN51", "nombre": "GENERADOR DE H2", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-GEN51", "nombre": "GENERADOR DE H2", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-11-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-GEN51', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-GEN51', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        52, 'INT-GAMB-AIRE-GEN52', '18990-0000-52', '199800149',
        'GENERADOR DE H2', 'PACKARD', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        53, 'INT-GAMB-AIRE-GEN53', '18990-0000-53', '199800149',
        'GENERADOR DE HIDROGENO', 'Sin Información', 'Sin Información', '420439',
        'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        54, 'INT-GAMB-AIRE-GIL54', '18990-0000-54', '199711186',
        'GILIAN CALIBRADOR DE FLUJO', 'GILIAN', 'Sin Información', '390835609',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        55, 'INT-GAMB-AIRE-ANA55', '18010-0009-55', '199713188',
        'ANALIZADOR DE HC', 'HORIBA', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        56, 'INT-GAMB-AIRE-INT56', '18990-0000-56', '199712737',
        'Interfase', 'PE Nelson', 'PE Nelson', '7240252202',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        57, 'INT-GAMB-AIRE-INT57', '18990-0000-57', '199712736',
        'Interfase', 'PE Nelson', 'PE Nelson', '7018272972',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        58, 'INT-GAMB-AIRE-MEZ58', '18010-0148-58', '199711189',
        'MEZCLADOR DE GASES', 'ENVIRONIC', 'Sin Información', '7989-7081-6697',
        'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 44.0, 66.67,
        'Obsolescencia Media', 7.75, 'Riesgo Alto',
        2.0, 'Mejora Continua Menor', 'ALTO RIESGO OPERACIONAL',
        '', '', NULL,
        '', '', '2027-12-10',
        '{"tag_pdvsa": "INT-GAMB-AIRE-MEZ58", "nombre": "MEZCLADOR DE GASES", "laboratorio": "Aire (Calidad de Aire)", "ff": 2.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 44.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-MEZ58", "nombre": "MEZCLADOR DE GASES", "laboratorio": "Aire (Calidad de Aire)", "eol": 2.0, "rep": 2.0, "met": 1.0, "ant": 3.0, "suma_puntos": 8.0, "iobs": 66.67, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "ALTO RIESGO OPERACIONAL", "decision_sugerida_riesgo": "Preservación / RCM Mandatorio / Inspección", "prioridad_oportunidad": "Mejora Continua Menor", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": "2027-12-10"}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MEZ58', 2.0, 10.0, 2.0, 1.0, 1.0, 22.0, 44.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MEZ58', 2.0, 2.0, 1.0, 3.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        59, 'INT-GAMB-AIRE-MEZ59', '18010-0148-59', '199713212',
        'MEZCLADOR DE GASES', 'ENVIRONICS', 'Sin Información', '2-321312',
        'Aire (Calidad de Aire)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        60, 'INT-GAMB-AIRE-DES60', '18010-0056-60', '199711915',
        'DESECADOR DE FILTROS', 'NIKKO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        61, 'INT-GAMB-AIRE-MED61', '18010-0217-61', '199711906',
        'MEDIDOR DE TEMP, HUM T PRESION', 'Sin Información', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        62, 'INT-GAMB-AIRE-MON62', '18990-0000-62', '199711261',
        'MONITOR', 'HP', 'Sin Información', '900372',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        63, 'INT-GAMB-AIRE-ANA63', '18010-0009-63', '199711284',
        'ANALIZADOR DE HC', 'HORIBA', 'APNA-360', '574635105',
        'Aire (Calidad de Aire)', 'Sin Información', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        64, 'INT-GAMB-AIRE-BUR64', '18990-0000-64', '199711185',
        'BURBUJOMETRO DE AIRE', 'Sin Información', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        65, 'INT-GAMB-AIRE-MUE65', '18990-0000-65', '199711215',
        'Muestreador de COV', 'Graseby', '97-323-100', '997494',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        66, 'INT-GAMB-AIRE-MUE66', '18990-0000-66', '199711260',
        'Muestreador de COV', 'Graseby', '97-323-100', '597467',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 45.0, NULL,
        '', 7.5, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-AIRE-MUE66", "nombre": "Muestreador de COV", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 4.0, "consecuencia": 15.0, "ic": 45.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-MUE66", "nombre": "Muestreador de COV", "laboratorio": "Aire (Calidad de Aire)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MUE66', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        67, 'INT-GAMB-AIRE-MUE67', '18990-0000-67', '199711270',
        'Muestreador de COV', 'Graseby', '97-323-100', '1297504',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        68, 'INT-GAMB-AIRE-MUE68', '18990-0000-68', '199713269',
        'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-D',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        69, 'INT-GAMB-AIRE-MUE69', '18990-0000-69', '199713217',
        'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-B',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        70, 'INT-GAMB-AIRE-MUE70', '18990-0000-70', '199713252',
        'Muestreador de partículas', 'ANDERSEN', '2000H', 'Sin Información',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        71, 'INT-GAMB-AIRE-MUE71', '18990-0000-71', '199713216',
        'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', 'IC30-2',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        72, 'INT-GAMB-AIRE-MUE72', '18990-0000-72', '199713268',
        'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-A',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        73, 'INT-GAMB-AIRE-BAL73', '18010-0025-73', '199712933',
        'Balanza Analítica', 'METTLER TOLEDO', 'AB204', '29225',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        74, 'INT-GAMB-AIRE-TER74', '18010-0217-74', '20060',
        'Termohigrómetro 2', 'EXTECH', 'SD700', 'Q673553',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        75, 'INT-GAMB-AIRE-TER75', '18010-0217-75', '20060',
        'Termohigrómetro 3', 'EXTECH', 'SD700', 'Q673538',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        76, 'INT-GAMB-AIRE-MUE76', '18990-0000-76', '199711128',
        'Muestreador de partículas', 'GRASEBY', '2000H', '4327-C',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        77, 'INT-GAMB-AIRE-MUE77', '18990-0000-77', '199711258',
        'Muestreador de partículas', 'GRASEBY', '2000H', 'Sin Información',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        78, 'INT-GAMB-AIRE-BAL78', '18010-0025-78', '199711426',
        'Balanza (Microbalanza)', 'METTLER TOLEDO', '650280', 'Sin Información',
        'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        79, 'INT-GAMB-AIRE-PRE79', '18990-0000-79', '200602254',
        'Preconcentrador', 'Entech', '7100', 'Sin Información',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        80, 'INT-GAMB-AIRE-ANA80', '18010-0009-80', '199711197',
        'Analizador de dióxido de azufre (SO2)', 'THERMO', '45C', 'Sin Información',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        81, 'INT-GAMB-AIRE-ANA81', '18010-0009-81', '200601653',
        'Analizador de dioxidos de nitrogeno (NO2)', 'TELEDYNE', '201E', '071',
        'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        82, 'INT-GAMB-AIRE-ANA82', '18010-0009-82', '199712974',
        'Analizador de Monoxido de Carbono', 'Thermo', '48C', '48c63285325',
        'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', 5.75, 'Riesgo Medio',
        6.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-AIRE-ANA82", "nombre": "Analizador de Monoxido de Carbono", "laboratorio": "Aire (Calidad de Aire)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-AIRE-ANA82", "nombre": "Analizador de Monoxido de Carbono", "laboratorio": "Aire (Calidad de Aire)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "OBSOLESCENCIA ALTA", "decision_sugerida_riesgo": "Reemplazo Planificado a Mediano Plazo", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "Implementar y Adquirir en el Plan Operativo Corto Plazo", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA82', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA82', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        83, 'INT-GAMB-AIRE-QUI83', '18990-0000-83', '199711125',
        'QUINTOX', 'KANE-MAY', 'Sin Información', '0490-1176',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        84, 'INT-GAMB-AIRE-RAD84', '18990-0000-84', '199711924',
        'RADAR ACUSTICO', 'REMTECH', 'Sin Información', 'WVT09ABTWW',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        85, 'INT-GAMB-AIRE-SIN85', '18990-0000-85', '199711142',
        'SINGLE PROBE CONTROLLER', 'TERMO', 'Sin Información', 'Sin Información',
        'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        86, 'INT-GAMB-AIRE-TES86', '18010-0156-86', '199712940',
        'TESTER', 'MICRONTA', 'Sin Información', '900241',
        'Aire (Calidad de Aire)', 'Media', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        87, 'INT-GAMB-BIOT-AGI87', '18010-0001-87', '199709024',
        'AGITADOR VORTEX', 'GENIE 2', 'Sin información', '2-321312',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-AGI87", "nombre": "AGITADOR VORTEX", "laboratorio": "Biotecnología", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-AGI87", "nombre": "AGITADOR VORTEX", "laboratorio": "Biotecnología", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AGI87', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AGI87', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        88, 'INT-GAMB-BIOT-AGI88', '18010-0001-88', '199712070',
        'AGITADOR VORTEX', 'MAXMIX', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        89, 'INT-GAMB-BIOT-AGI89', '18010-0001-89', '199712046',
        'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        90, 'INT-GAMB-BIOT-AUT90', '18010-0024-90', '199710937',
        'AUTO CLAVE', 'Sin información', 'Sin información', '159454',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-AUT90", "nombre": "AUTO CLAVE", "laboratorio": "Biotecnología", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-AUT90", "nombre": "AUTO CLAVE", "laboratorio": "Biotecnología", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        91, 'INT-GAMB-BIOT-AUT91', '18010-0024-91', '200200749',
        'AUTO CLAVE', 'Sin información', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        92, 'INT-GAMB-BIOT-BAC92', '18990-0000-92', '199709021',
        'BACTI INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        93, 'INT-GAMB-BIOT-BAL93', '18010-0025-93', '200601465',
        'BALANZA ELECTRONICA', 'ADVENTURER', 'Sin información', 'K199 1227230442 P',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        94, 'INT-GAMB-BIOT-BOM94', '18010-0032-94', '199711938',
        'BOMBA PERISTATICA', 'MEB CORP', 'Sin información', 'M9000403',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        95, 'INT-GAMB-BIOT-CAM95', '18010-0037-95', '199710906',
        'CAMARA ANAEROBICA', 'MECAPLEX', 'Sin información', '91218',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        96, 'INT-GAMB-BIOT-CAM96', '18010-0037-96', '199712226',
        'CAMARA DE ELECTROFORESIS', 'Thermo Scientific', 'Sin información', 'H5-9255',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-CAM96", "nombre": "CAMARA DE ELECTROFORESIS", "laboratorio": "Biotecnología", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-CAM96", "nombre": "CAMARA DE ELECTROFORESIS", "laboratorio": "Biotecnología", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        97, 'INT-GAMB-BIOT-CAM97', '18010-0037-97', '199712227',
        'CAMARA DE ELECTROFORESIS', 'Thermo Scientific', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        98, 'INT-GAMB-BIOT-CAM98', '18010-0095-98', '199712210',
        'CAMPANA # 1  DE EXTRACCION CON 2 COMPARTIMIENTOS', 'Sin información', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        99, 'INT-GAMB-BIOT-CAM99', '18010-0095-99', '199712248',
        'CAMPANA # 2 DE EXTRACCION CON 2 COMPARTIMIENTOS', 'Sin información', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        100, 'INT-GAMB-BIOT-CAM100', '18010-0095-100', '199710927',
        'CAMPANA DE BIOSEGURIDAD', 'KOTTERMAN', 'Sin información', 'Sin Información',
        'Biotecnología', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        101, 'INT-GAMB-BIOT-CAM101', '18010-0095-101', '199710926',
        'CAMPANA DE BIOSEGURIDAD', 'KOTTERMAN', 'Sin información', 'Sin Información',
        'Biotecnología', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        102, 'INT-GAMB-BIOT-CAM102', '18010-0095-102', '199710929',
        'CAMPANA DE BIOSEGURIDAD', 'LABCONCO', 'Sin información', '214803',
        'Biotecnología', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-CAM102", "nombre": "CAMPANA DE BIOSEGURIDAD", "laboratorio": "Biotecnología", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-CAM102", "nombre": "CAMPANA DE BIOSEGURIDAD", "laboratorio": "Biotecnología", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        103, 'INT-GAMB-BIOT-CEN103', '18010-0042-103', '200603560',
        'CENTRIFUGA', 'EPPENDORF.', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        104, 'INT-GAMB-BIOT-CON104', '18990-0000-104', '20130245',
        'CONGELADOR VERTICAL', 'WHIRPOOL', 'Sin información', 'WVT09ABTWW',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        105, 'INT-GAMB-BIOT-DES105', '18010-0058-105', '199710935',
        'DESTILADOR', 'MEGAPURE', 'Sin información', '7989-7081-6697',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        106, 'INT-GAMB-BIOT-DIS106', '18010-0065-106', '199710947',
        'DISPENSADOR AUTOMATICO', 'MASTERFLEX', 'Sin información', '651728',
        'Biotecnología', 'Baja', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        107, 'INT-GAMB-BIOT-EST107', '18010-0092-107', '199710925',
        'ESTUFA', 'MEMMERT', 'Sin información', '900372',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        108, 'INT-GAMB-BIOT-EST108', '18010-0092-108', '199710936',
        'ESTUFA', 'MEMMERT', 'Sin información', '900241',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 48.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-EST108", "nombre": "ESTUFA", "laboratorio": "Biotecnología", "ff": 2.0, "io": 10.0, "fo": 2.0, "cm": 3.0, "sha": 1.0, "consecuencia": 24.0, "ic": 48.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-EST108", "nombre": "ESTUFA", "laboratorio": "Biotecnología", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-EST108', 2.0, 10.0, 2.0, 3.0, 1.0, 24.0, 48.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-EST108', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        109, 'INT-GAMB-BIOT-FER109', '18010-0063-109', '199710933',
        'FERMENTADOR', 'BIOSTAT', 'Sin información', '665',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        110, 'INT-GAMB-BIOT-FRE110', '18010-0159-110', '199710930',
        'FREEZER  - 86°C', 'FORMA SCIENTIFIC', 'Sin información', '85332-241',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        111, 'INT-GAMB-BIOT-INC111', '18010-0092-111', '199710939',
        'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        112, 'INT-GAMB-BIOT-INC112', '18010-0092-112', '199712151',
        'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        113, 'INT-GAMB-BIOT-INC113', '18010-0092-113', '199712152',
        'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        114, 'INT-GAMB-BIOT-INC114', '18010-0123-114', '199710905',
        'INCUBADOR (AGIT. Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '390835609',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        115, 'INT-GAMB-BIOT-INC115', '18010-0123-115', '199710943',
        'INCUBADOR (AGIT. Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '981118325',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        116, 'INT-GAMB-BIOT-INC116', '18010-0123-116', '199710944',
        'INCUBADOR AGIT .Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '191026841',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 22.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-INC116", "nombre": "INCUBADOR AGIT .Y TEMP.)", "laboratorio": "Biotecnología", "ff": 1.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 22.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-INC116", "nombre": "INCUBADOR AGIT .Y TEMP.)", "laboratorio": "Biotecnología", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 3.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-INC116', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-INC116', 1.0, 2.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        117, 'INT-GAMB-BIOT-INC117', '18010-0123-117', '199710945',
        'INCUBADOR CON AGITACION Y TEMPERATURA', 'LABLINE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        118, 'INT-GAMB-BIOT-INC118', '18010-0123-118', '199710924',
        'INCUBADOR ESTATICO', 'LABLINE', 'Sin información', '0490-1176',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        119, 'INT-GAMB-BIOT-MEC119', '18010-0143-119', '199711937',
        'MECHERO DE CAMPANA', 'FIREBOY', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        120, 'INT-GAMB-BIOT-MIC120', '18010-0150-120', '199710918',
        'MICROSCOPIO', 'NIKON', 'Sin información', '320939',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 22.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-MIC120", "nombre": "MICROSCOPIO", "laboratorio": "Biotecnología", "ff": 1.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 22.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-MIC120", "nombre": "MICROSCOPIO", "laboratorio": "Biotecnología", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 3.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MIC120', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MIC120', 1.0, 2.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        121, 'INT-GAMB-BIOT-MIC121', '18010-0150-121', '199710919',
        'MICROSCOPIO', 'ZEIZZ', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        122, 'INT-GAMB-BIOT-CEN122', '18010-0042-122', '-',
        'CENTRÍFUGA  MINI CENTRÍFUGA', 'FISHER SCIENTIFIC', 'Sin información', '100913221',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        123, 'INT-GAMB-BIOT-PLA123', '18010-0001-123', '199712241',
        'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', '6389-3080-0814',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        124, 'INT-GAMB-BIOT-PLA124', '18010-0001-124', '199712236',
        'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        125, 'INT-GAMB-BIOT-PLA125', '18010-0001-125', '199712239',
        'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        126, 'INT-GAMB-BIOT-PLA126', '18010-0001-126', '199710966',
        'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        127, 'INT-GAMB-BIOT-PLA127', '18010-0001-127', '199712235',
        'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        128, 'INT-GAMB-BIOT-PLA128', '18010-0001-128', '199712036',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'THERMOLYNE', 'Sin información', '612911-018010',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        129, 'INT-GAMB-BIOT-PLA129', '18010-0001-129', '199712215',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO', 'CORNING', 'Sin información', 'Sin información',
        'Biotecnología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        130, 'INT-GAMB-BIOT-REF130', '18010-0159-130', '-',
        'REFRIGERADOR', 'Sin información', 'Sin información', 'Cod. Inventario 592-0105',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        131, 'INT-GAMB-BIOT-REF131', '18010-0159-131', '200601032',
        'REFRIGERADOR', 'LAB LINE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        132, 'INT-GAMB-BIOT-ROT132', '18010-0058-132', '200200093',
        'ROTAVAPOR', 'BUCHI', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        133, 'INT-GAMB-BIOT-AGI133', '18010-0001-133', '199712240',
        'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', '2-278554',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        134, 'INT-GAMB-BIOT-AGI134', '18010-0001-134', '199710938',
        'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        135, 'INT-GAMB-BIOT-AGI135', '18010-0001-135', 'Sin Información',
        'AGITADOR VORTEX', 'VM-2000', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        136, 'INT-GAMB-BIOT-DIS136', '18010-0065-136', 'Sin Información',
        'dispensador automatico', 'IBX Instruments', 'P 10 +', '2025113079',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        137, 'INT-GAMB-BIOT-CEN137', '18010-0042-137', 'Sin Información',
        'CENTRÍFUGA microcentrifuga', 'dinamic', 'velocity 15 pro', '709600L',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        138, 'INT-GAMB-BIOT-BIO138', '18990-0000-138', '199709199',
        'BIOSCREEN MBR', 'Bioscreen', 'Sin información', '110001-438',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', 7.5, 'Riesgo Alto',
        NULL, '', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-BIO138", "nombre": "BIOSCREEN MBR", "laboratorio": "Biotecnología", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-BIO138", "nombre": "BIOSCREEN MBR", "laboratorio": "Biotecnología", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BIO138', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BIO138', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        139, 'INT-GAMB-BIOT-CUE139', '18990-0000-139', '199710941',
        'CUENTA COLONIAS', 'DARKFIELD', 'Sin información', 'Sin Información',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 4.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-CUE139", "nombre": "CUENTA COLONIAS", "laboratorio": "Biotecnología", "ff": 1.0, "io": 1.0, "fo": 1.0, "cm": 2.0, "sha": 1.0, "consecuencia": 4.0, "ic": 4.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-CUE139", "nombre": "CUENTA COLONIAS", "laboratorio": "Biotecnología", "eol": 1.0, "rep": 1.0, "met": 2.0, "ant": 3.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CUE139', 1.0, 1.0, 1.0, 2.0, 1.0, 4.0, 4.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CUE139', 1.0, 1.0, 2.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        140, 'INT-GAMB-BIOT-BAL140', '18010-0025-140', 'Sin Información',
        'BALANZA ELETRONICA', 'Metler toledo', 'Sin información', '1125473951',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-BAL140", "nombre": "BALANZA ELETRONICA", "laboratorio": "Biotecnología", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-BAL140", "nombre": "BALANZA ELETRONICA", "laboratorio": "Biotecnología", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BAL140', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BAL140', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        141, 'INT-GAMB-BIOT-HOM141', '18010-0148-141', '200604903',
        'HOMOGEINIZADOR', 'THERMO SCIENTIFIC', 'Sin información', 'Sin Información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        142, 'INT-GAMB-BIOT-LAM142', '18990-0000-142', '199712234',
        'LAMPARA DE UV PARA LA CAMARA DE ELECTROPHERESIS', 'PHOTODOC-IT', 'Sin información', 'SLA1-1092-1064',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        143, 'INT-GAMB-BIOT-MIC143', '18990-0000-143', 'Sin Información',
        'MICROONDAS', 'LG', 'Sin información', '811TAXT06114',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        144, 'INT-GAMB-BIOT-MUL144', '18990-0000-144', 'Sin Información',
        'multiparametro', 'APERA', '1220361005', 'PC 910',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-MUL144", "nombre": "multiparametro", "laboratorio": "Biotecnología", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-MUL144", "nombre": "multiparametro", "laboratorio": "Biotecnología", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        145, 'INT-GAMB-BIOT-MUL145', '18010-0156-145', '200604478',
        'MULTISKAN', 'ASCENT', 'Sin información', 'Sin Información',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        146, 'INT-GAMB-BIOT-MUL146', '18010-0156-146', '20060042',
        'MULTISKAN', 'ACCENT', 'Sin información', 'Sin Información',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 17.0, 66.67,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-MUL146", "nombre": "MULTISKAN", "laboratorio": "Biotecnología", "ff": 1.0, "io": 10.0, "fo": 1.0, "cm": 3.0, "sha": 4.0, "consecuencia": 17.0, "ic": 17.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-MUL146", "nombre": "MULTISKAN", "laboratorio": "Biotecnología", "eol": 2.0, "rep": 2.0, "met": 2.0, "ant": 2.0, "suma_puntos": 8.0, "iobs": 66.67, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL146', 1.0, 10.0, 1.0, 3.0, 4.0, 17.0, 17.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL146', 2.0, 2.0, 2.0, 2.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        147, 'INT-GAMB-BIOT-SIS147', '18990-0000-147', '200604352',
        'SISTEMA DE DOCUMENTACION DE GELES.', 'Sin información', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        148, 'INT-GAMB-BIOT-TER148', '18990-0000-148', '200603187',
        'TERMOCICLADOR', 'ESCO', 'Sin información', 'Sin información',
        'Biotecnología', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        149, 'INT-GAMB-BIOT-TER149', '18010-0217-149', '200604390',
        'TERMOHIGROMETRO BAROMETRO.', 'Extech', 'Sin información', 'S:Q673623',
        'Biotecnología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 5.0, 41.67,
        'Obsolescencia Baja', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-BIOT-TER149", "nombre": "TERMOHIGROMETRO BAROMETRO.", "laboratorio": "Biotecnología", "ff": 1.0, "io": 1.0, "fo": 2.0, "cm": 2.0, "sha": 1.0, "consecuencia": 5.0, "ic": 5.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-BIOT-TER149", "nombre": "TERMOHIGROMETRO BAROMETRO.", "laboratorio": "Biotecnología", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 1.0, "suma_puntos": 5.0, "iobs": 41.67, "estatus_obsolescencia": "Obsolescencia Baja"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-TER149', 1.0, 1.0, 2.0, 2.0, 1.0, 5.0, 5.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-TER149', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        150, 'INT-GAMB-DESE-DES150', '18010-0058-150', '199800510',
        'destilador', 'Barnstead', 'MP- 6a', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        151, 'INT-GAMB-DESE-AGI151', '18010-0001-151', '1997-10871',
        'Agitador Magnético', 'LABLINE Instruments', '1278', '0993-2607',
        'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        152, 'INT-GAMB-DESE-AGI152', '18010-0001-152', '2006-04543',
        'Agitador orbital', 'Heidolph', 'UNIMAX1010DT', '100503933',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 26.0, 41.67,
        'Obsolescencia Baja', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-AGI152", "nombre": "Agitador orbital", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 1.0, "io": 5.0, "fo": 4.0, "cm": 2.0, "sha": 4.0, "consecuencia": 26.0, "ic": 26.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-AGI152", "nombre": "Agitador orbital", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 1.0, "suma_puntos": 5.0, "iobs": 41.67, "estatus_obsolescencia": "Obsolescencia Baja"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-AGI152', 1.0, 5.0, 4.0, 2.0, 4.0, 26.0, 26.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-AGI152', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        153, 'INT-GAMB-DESE-AGI153', '18010-0001-153', '1997-11093',
        'Agitador orbital', 'Thermolyne', 'AROS 160', '660911126619',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        154, 'INT-GAMB-DESE-AGI154', '18010-0001-154', '1997-11092',
        'Agitador orbital', 'Thermolyne', 'AROS 160', '666911126616',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        155, 'INT-GAMB-DESE-BOM155', '18010-0032-155', '1997-10873',
        'Bomba de vacío', 'LEYBOLD', 'D8A', '92500067',
        'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        156, 'INT-GAMB-DESE-CEN156', '18010-0042-156', '1997-711050',
        'Centrífuga', 'DAMON/IEC', 'HN-SII', '23556644',
        'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        157, 'INT-GAMB-DESE-EST157', '18010-0092-157', '199710850',
        'Estufa', 'Stabil Therm', 'D-5226-Q', 'OU-11189',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        158, 'INT-GAMB-DESE-EST158', '18010-0092-158', '199710877',
        'Estufa', 'Fisher', '550', '0401393',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        159, 'INT-GAMB-DESE-EST159', '18010-0092-159', '199710852',
        'Estufa', 'VWR', '1600 HAFO Series', 'MD 9607',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        160, 'INT-GAMB-DESE-PHM160', '18010-0145-160', '20130430',
        'pHmetro', 'Metrohm', '827', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        161, 'INT-GAMB-DESE-PLA161', '18010-0001-161', '199712037',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'Thermolyne', 'Cimarec 3', '612911018008',
        'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        162, 'INT-GAMB-DESE-REF162', '18990-0000-162', '200601770',
        'Refrigerador', 'Fisher Scientific', '13-986-450R', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        163, 'INT-GAMB-DESE-ROT163', '18010-0058-163', '200200408',
        'Rotavapor', 'Yamato', 'BM400', 'BO300035',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-ROT163", "nombre": "Rotavapor", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-ROT163", "nombre": "Rotavapor", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-ROT163', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-ROT163', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        164, 'INT-GAMB-DESE-ROT164', '18010-0058-164', '200100222',
        'Rotavapor', 'BUCHI', 'B490/R200', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        165, 'INT-GAMB-DESE-ROT165', '18010-0058-165', '199800003',
        'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        166, 'INT-GAMB-DESE-ROT166', '18010-0058-166', '199800136',
        'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        167, 'INT-GAMB-DESE-ROT167', '18010-0058-167', '199711053',
        'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        168, 'INT-GAMB-DESE-REF168', '18010-0159-168', 'Sin Información',
        'Refrigerador', 'LIEBHERR', 'SCIENTIFIC', '903335200',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-REF168", "nombre": "Refrigerador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-REF168", "nombre": "Refrigerador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-REF168', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-REF168', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        169, 'INT-GAMB-DESE-EQU169', '18010-0021-169', 'Sin Información',
        'Equipo Tamizador', 'FRITSCH', 'SPARTAN', '03.8020/06308',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 24.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-EQU169", "nombre": "Equipo Tamizador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 2.0, "io": 10.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 12.0, "ic": 24.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-EQU169", "nombre": "Equipo Tamizador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 2.0, "rep": 1.0, "met": 1.0, "ant": 3.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-EQU169', 2.0, 10.0, 1.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-EQU169', 2.0, 1.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        170, 'INT-GAMB-DESE-BAL170', '18010-0025-170', '2006-01427',
        'Balanza Analítica', 'Metler toledo', 'AB204-SN', '1127113130',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        171, 'INT-GAMB-DESE-BAL171', '18010-0025-171', '199710858',
        'Balanza Analítica', 'Mettler', 'AT 201', 'P05562',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        172, 'INT-GAMB-DESE-CON172', '18990-0000-172', '200604385',
        'Conductímetro', 'HACH', 'SenION+', '213097',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 24.0, 50.0,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-CON172", "nombre": "Conductímetro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 2.0, "io": 10.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 12.0, "ic": 24.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-CON172", "nombre": "Conductímetro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 1.0, "rep": 1.0, "met": 1.0, "ant": 3.0, "suma_puntos": 6.0, "iobs": 50.0, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-CON172', 2.0, 10.0, 1.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-CON172', 1.0, 1.0, 1.0, 3.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        173, 'INT-GAMB-DESE-EXT173', '18010-0095-173', 'Sin Información',
        'Extractor de aceites y grasas', 'VELP Scientifica', 'SER148', '53123',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 32.0, 100.0,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-EXT173", "nombre": "Extractor de aceites y grasas", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 4.0, "io": 5.0, "fo": 1.0, "cm": 2.0, "sha": 1.0, "consecuencia": 8.0, "ic": 32.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-EXT173", "nombre": "Extractor de aceites y grasas", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 3.0, "rep": 3.0, "met": 3.0, "ant": 3.0, "suma_puntos": 12.0, "iobs": 100.0, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-EXT173', 4.0, 5.0, 1.0, 2.0, 1.0, 8.0, 32.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-EXT173', 3.0, 3.0, 3.0, 3.0, 12.0, 100.0, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        174, 'INT-GAMB-DESE-MIC174', '18990-0000-174', '200602349',
        'Microondas', 'CEM', 'MarsXpress', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        175, 'INT-GAMB-DESE-MUL175', '18990-0000-175', 'Sin Información',
        'multiparametro', 'APERA INSTRUMENTS', 'PC 910', '1220361007',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-MUL175", "nombre": "multiparametro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-MUL175", "nombre": "multiparametro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-MUL175', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-MUL175', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        176, 'INT-GAMB-DESE-MUF176', '18010-0158-176', 'Sin Información',
        'Mufla', 'Fisher Scientific', '550-126', '1511070561427',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        177, 'INT-GAMB-DESE-PUL177', '18990-0000-177', 'Sin Información',
        'pulverizador', 'Herzog', 'HSM-250H', 'MA 19366-1',
        'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        178, 'INT-GAMB-DESE-REC178', '18010-0027-178', '199800542',
        'Recirculador', 'NESLAB', 'RTE-111', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-REC178", "nombre": "Recirculador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-REC178", "nombre": "Recirculador", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-REC178', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-REC178', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        179, 'INT-GAMB-DESE-REC179', '18010-0081-179', '199710820',
        'Recirculador', 'NESLAB', 'RTE-111', 'Sin Información',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        180, 'INT-GAMB-DESE-TER180', '18010-0217-180', '200604887',
        'Termohigrómetro', 'EXTECH', 'SD700', 'Q673624',
        'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 66.0, NULL,
        '', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-DESE-TER180", "nombre": "Termohigrómetro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "ff": 3.0, "io": 5.0, "fo": 4.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 66.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-DESE-TER180", "nombre": "Termohigrómetro", "laboratorio": "Desechos ( Tratabilidad de Desechos)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-TER180', 3.0, 5.0, 4.0, 1.0, 1.0, 22.0, 66.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        181, 'INT-GAMB-ECOT-MED181', '18010-0145-181', '200200026',
        'MEDIDOR DE MULTIPARÁMETROS', 'HACH', 'SENSION 378', '40400002652',
        'Ecotoxicología', 'Media', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 6.0, 91.67,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-MED181", "nombre": "MEDIDOR DE MULTIPARÁMETROS", "laboratorio": "Ecotoxicología", "ff": 2.0, "io": 1.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 3.0, "ic": 6.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-MED181", "nombre": "MEDIDOR DE MULTIPARÁMETROS", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 3.0, "met": 2.0, "ant": 3.0, "suma_puntos": 11.0, "iobs": 91.67, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED181', 2.0, 1.0, 1.0, 1.0, 1.0, 3.0, 6.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED181', 3.0, 3.0, 2.0, 3.0, 11.0, 91.67, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        182, 'INT-GAMB-ECOT-BAL182', '18010-0025-182', '199710999',
        'BALANZA ANALÍTICA', 'METTLER', 'AJ180', '930',
        'Ecotoxicología', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        183, 'INT-GAMB-ECOT-BAL183', '18010-0025-183', '200100102',
        'BALANZA ANALÍTICA', 'METTLER TOLEDO', 'PB3002-S', '1120201863',
        'Ecotoxicología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 22.0, 83.33,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-BAL183", "nombre": "BALANZA ANALÍTICA", "laboratorio": "Ecotoxicología", "ff": 1.0, "io": 5.0, "fo": 4.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 22.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-BAL183", "nombre": "BALANZA ANALÍTICA", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL183', 1.0, 5.0, 4.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL183', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        184, 'INT-GAMB-ECOT-BAL184', '18010-0025-184', '200600397',
        'BALANZA ANALÍTICA', 'AND', 'GR200', '14220316',
        'Ecotoxicología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 22.0, 83.33,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-BAL184", "nombre": "BALANZA ANALÍTICA", "laboratorio": "Ecotoxicología", "ff": 1.0, "io": 10.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 22.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-BAL184", "nombre": "BALANZA ANALÍTICA", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL184', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL184', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        185, 'INT-GAMB-ECOT-MED185', '18990-0000-185', '200200426',
        'MEDIDOR DE OXÍGENO DISUELTO PORTÁTIL', 'YELLOW SPRING INSTRUMENT CO. YSI', 'Sin información', '02D1306',
        'Ecotoxicología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 7.0, 91.67,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-MED185", "nombre": "MEDIDOR DE OXÍGENO DISUELTO PORTÁTIL", "laboratorio": "Ecotoxicología", "ff": 1.0, "io": 5.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 7.0, "ic": 7.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-MED185", "nombre": "MEDIDOR DE OXÍGENO DISUELTO PORTÁTIL", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 3.0, "met": 2.0, "ant": 3.0, "suma_puntos": 11.0, "iobs": 91.67, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED185', 1.0, 5.0, 1.0, 1.0, 1.0, 7.0, 7.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED185', 3.0, 3.0, 2.0, 3.0, 11.0, 91.67, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        186, 'INT-GAMB-ECOT-MIC186', '18990-0000-186', '199800472',
        'MICROTOX', 'AZUR ENVIRONMENTAL', 'OMNI/M500', '5001577',
        'Ecotoxicología', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 132.0, 83.33,
        'Obsolescencia Crítica', 8.25, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-MIC186", "nombre": "MICROTOX", "laboratorio": "Ecotoxicología", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 3.0, "sha": 1.0, "consecuencia": 44.0, "ic": 132.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-MIC186", "nombre": "MICROTOX", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC186', 3.0, 10.0, 4.0, 3.0, 1.0, 44.0, 132.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC186', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        187, 'INT-GAMB-ECOT-REF187', '18010-0196-187', '199709004',
        'REFRACTÓMETRO PORTÁTIL', 'ATAGO', 'S/MILL 8904', 'Sin Información',
        'Ecotoxicología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        188, 'INT-GAMB-ECOT-REF188', '18010-0196-188', 'Sin Información',
        'REFRACTÓMETRO PORTÁTIL', 'PORTABLE REFRAKTOMETER', '13-946-27', 'Sin Información',
        'Ecotoxicología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        189, 'INT-GAMB-ECOT-PLA189', '18010-0001-189', '1997708992',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO GRANDE', 'THERMOLYNE', 'SP47235-60', '612911018002',
        'Ecotoxicología', '', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        190, 'INT-GAMB-ECOT-PLA190', '18010-0001-190', '199710964',
        'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130849',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 10.0, 75.0,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-PLA190", "nombre": "PLANCHA DE AGITACIÓN PEQUEÑA", "laboratorio": "Ecotoxicología", "ff": 1.0, "io": 5.0, "fo": 1.0, "cm": 1.0, "sha": 4.0, "consecuencia": 10.0, "ic": 10.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-PLA190", "nombre": "PLANCHA DE AGITACIÓN PEQUEÑA", "laboratorio": "Ecotoxicología", "eol": 2.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 9.0, "iobs": 75.0, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA190', 1.0, 5.0, 1.0, 1.0, 4.0, 10.0, 10.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA190', 2.0, 2.0, 2.0, 3.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        191, 'INT-GAMB-ECOT-PLA191', '18010-0001-191', '199710966',
        'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130858',
        'Ecotoxicología', '', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        192, 'INT-GAMB-ECOT-PLA192', '18010-0001-192', '199710965',
        'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130859',
        'Ecotoxicología', '', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        193, 'INT-GAMB-ECOT-EST193', '18010-0092-193', '199710995',
        'ESTUFA', 'BLUE M ELECTRIC COMPANY', 'Sin información', 'Sin información',
        'Ecotoxicología', '', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        194, 'INT-GAMB-ECOT-MEZ194', '18010-0148-194', '200100115',
        'MEZCLADORA', 'IKA LABORTECHNIK', 'RW20 N 51', '3106887',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        195, 'INT-GAMB-ECOT-SIS195', '18010-0097-195', '199800420',
        'SISTEMA DE FILTRACIÓN DE CARBÓN ACTIVADO', 'AQUATIC', '416014B', 'Sin Información',
        'Ecotoxicología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        196, 'INT-GAMB-ECOT-NEV196', '18010-0159-196', '200200602',
        'NEVERA', 'WHIRLPOOL', 'ETILFKXKT02', 'EM3823349',
        'Ecotoxicología', '', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        197, 'INT-GAMB-ECOT-MIC197', '18010-0150-197', '199711115',
        'MICROSCOPIO ÓPTICO AXIOPLANT DE LUZ TRANSMITIDA', 'ZEISS', '7082', '451485',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        198, 'INT-GAMB-ECOT-MIC198', '18010-0150-198', '199711114',
        'MICROSCOPIO ESTEREOSCÓPICO', 'ZEISS', 'STEMI SVII', '415826',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 16.0, 83.33,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-MIC198", "nombre": "MICROSCOPIO ESTEREOSCÓPICO", "laboratorio": "Ecotoxicología", "ff": 2.0, "io": 5.0, "fo": 1.0, "cm": 2.0, "sha": 1.0, "consecuencia": 8.0, "ic": 16.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-MIC198", "nombre": "MICROSCOPIO ESTEREOSCÓPICO", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC198', 2.0, 5.0, 1.0, 2.0, 1.0, 8.0, 16.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC198', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        199, 'INT-GAMB-ECOT-MIC199', '18010-0150-199', '200600415',
        'MICROSCOPIO INVERTIDO', 'LEICA', 'DMIL', '90135002',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', 6.75, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-MIC199", "nombre": "MICROSCOPIO INVERTIDO", "laboratorio": "Ecotoxicología", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-MIC199", "nombre": "MICROSCOPIO INVERTIDO", "laboratorio": "Ecotoxicología", "eol": 3.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC199', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC199', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        200, 'INT-GAMB-ECOT-ADJ200', '18010-0001-200', '199711092',
        'ADJUSTABLE RECIPROCATING ORBITAL SHAKER', 'BARNSTEAD/THERMOLYNE', 'M66025', '660911126616',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        201, 'INT-GAMB-ECOT-CÁM201', '18990-0000-201', '200600416',
        'CÁMARA FOTOGRÁFICA DIGITAL PARA MICROSCOPIO', 'LEICA', 'DFC490', '148702206B',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        202, 'INT-GAMB-ECOT-LÁM202', '18990-0000-202', 'Sin Información',
        'LÁMPARA DE MERCURIO', 'LEISTUNGSELERKTRONIC JENA GmbH', 'mbq52ac-L IP20', '70370105235',
        'Ecotoxicología', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        203, 'INT-GAMB-ECOT-EST203', '18010-0092-203', 'Sin Información',
        'ESTUFA', 'FISHER SCIENTIFIC', '725-F', '1584070236548',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        204, 'INT-GAMB-ECOT-PLA204', '18010-0001-204', '199712239',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        205, 'INT-GAMB-ECOT-PLA205', '18010-0001-205', '199712105',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 10.0, 75.0,
        'Obsolescencia Crítica', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-ECOT-PLA205", "nombre": "PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA", "laboratorio": "Ecotoxicología", "ff": 1.0, "io": 5.0, "fo": 1.0, "cm": 1.0, "sha": 4.0, "consecuencia": 10.0, "ic": 10.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-ECOT-PLA205", "nombre": "PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA", "laboratorio": "Ecotoxicología", "eol": 2.0, "rep": 2.0, "met": 2.0, "ant": 3.0, "suma_puntos": 9.0, "iobs": 75.0, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA205', 1.0, 5.0, 1.0, 1.0, 4.0, 10.0, 10.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA205', 2.0, 2.0, 2.0, 3.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        206, 'INT-GAMB-ECOT-PLA206', '18010-0001-206', '199712235',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        207, 'INT-GAMB-ECOT-CAM207', '18010-0095-207', '199709018',
        'CAMPANA DE EXTRACCIÓN', 'Sin información', 'Sin información', 'Sin información',
        'Ecotoxicología', 'Alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        208, 'INT-GAMB-ECOT-DES208', '18010-0058-208', '199710991',
        'DESTILADOR', 'CORNING MEGA-PURE', '12 LITER AUTO MP12A', '146',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        209, 'INT-GAMB-ECOT-MIC209', '18010-0150-209', '199712278',
        'MICROSCOPIO ÓPTICO', 'LEICA', 'NO.31-75-05', '1588-LT',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        210, 'INT-GAMB-ECOT-PLA210', '18010-0001-210', '199710961',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO GRANDE', 'THERMOLYNE', 'SP42735-60', '612910909179',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        211, 'INT-GAMB-ECOT-BOM211', '18010-0032-211', '199708995',
        'BOMBA DE AGUA', 'JACUZZI BROS', '940226770', '4781012',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        212, 'INT-GAMB-ECOT-TER212', '18010-0217-212', 'Sin Información',
        'TERMOHIGRÓMETRO', 'TRACEABLE® BIG DIG', '6066N53', '61998285',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        213, 'INT-GAMB-ECOT-CÁM213', '18990-0000-213', '200601512',
        'CÁMARA DE CRECIMIENTO', 'CONVIRON', 'BDR 16', '70175',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        214, 'INT-GAMB-ECOT-CAM214', '18010-0095-214', '200602640',
        'CAMPANA DE FLUJO HORIZONTAL', 'LABCONCO', 'PURIFIER', '704694877',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        215, 'INT-GAMB-ECOT-MIC215', '18010-0150-215', 'Sin Información',
        'MICROSCOPIO ESTEREOSCÓPICO', 'NACIONAL OPTICAL & SCIENTIFIC INSTRUMENTS INC.', 'DC5-420TH', '12001315',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        216, 'INT-GAMB-ECOT-MIC216', '18990-0000-216', '200604479',
        'MICROTOX', 'MODERN WATER', 'M-500', '5002915',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        217, 'INT-GAMB-ECOT-NEV217', '18010-0159-217', '200600778',
        'NEVERA', 'BARNSTEAD INTERNATIONAL', '3751', '1422070563362',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        218, 'INT-GAMB-ECOT-MUF218', '18010-0158-218', '199711039',
        'MUFLA', 'NEY', 'M-525 SII', 'AKN9339-157',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        219, 'INT-GAMB-ECOT-DES219', '18010-0058-219', 'Sin Información',
        'DESTILADOR DE AGUA', 'GFL', '2004', '11669312J',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        220, 'INT-GAMB-ECOT-DES220', '18010-0058-220', 'Sin Información',
        'DESIONIZADOR DE AGUA', 'THERMO - BARNSTEAD', 'MEGA-PURE D1', '494240-39',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        221, 'INT-GAMB-ECOT-LAM221', '18990-0000-221', '199709740',
        'LAMPARA', 'ZEISS', 'KL 1500', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        222, 'INT-GAMB-ECOT-PLA222', '18010-0001-222', '199712236',
        'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'MAGNE-4', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        223, 'INT-GAMB-ECOT-MON223', '18990-0000-223', '2001689',
        'MONITOR', 'Sin Información', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        224, 'INT-GAMB-ECOT-CPU224', '18990-0000-224', '2000903',
        'CPU', 'VIT', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        225, 'INT-GAMB-ECOT-MON225', '18990-0000-225', '2048427',
        'MONITOR', 'SIRAGON', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        226, 'INT-GAMB-ECOT-CPU226', '18990-0000-226', '2048476',
        'CPU', 'SIRAGON', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        227, 'INT-GAMB-ECOT-LEC227', '18990-0000-227', '2018787',
        'LECTOR DE CODIGO', 'Sin Información', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        228, 'INT-GAMB-ECOT-REF228', '18010-0159-228', '200600778',
        'REFRIGERADOR', 'BARNSTEAD', 'Sin Información', 'Sin Información',
        'Ecotoxicología', '', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        229, 'INT-GAMB-EFLU-BAÑ229', '18010-0081-229', '199711052',
        'BAñO Recirculante', 'HAAKE', '001-0506', '9107797',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        230, 'INT-GAMB-EFLU-DES230', '18010-0058-230', '200200092',
        'Destilador de agua', 'BARNSTEAD', 'A440696', '675980714108',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 52.0, NULL,
        '', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-DES230", "nombre": "Destilador de agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": 2.0, "io": 10.0, "fo": 2.0, "cm": 2.0, "sha": 4.0, "consecuencia": 26.0, "ic": 52.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-DES230", "nombre": "Destilador de agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES230', 2.0, 10.0, 2.0, 2.0, 4.0, 26.0, 52.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        231, 'INT-GAMB-EFLU-ROT231', '18010-0058-231', '199800128',
        'Rotaevaporador', 'YAMATO', 'RE500', '45700044',
        'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        232, 'INT-GAMB-EFLU-MED232', '18010-0145-232', '200601015',
        'Medidor de pH', 'Thermo Orion', 'Orion 330', '17728',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        233, 'INT-GAMB-EFLU-MED233', '18010-0145-233', '200601014',
        'Medidor de conductividad', 'WTW', '197i', '517325',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        234, 'INT-GAMB-EFLU-BAT234', '18010-0095-234', '200600963',
        'Batería de Mantas Calefactoras para Digestión Kjeldahl y Extracción', 'Selecta', '6003294', '502696',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-BAT234", "nombre": "Batería de Mantas Calefactoras para Digestión Kjeldahl y Extracción", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-BAT234", "nombre": "Batería de Mantas Calefactoras para Digestión Kjeldahl y Extracción", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAT234', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAT234', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        235, 'INT-GAMB-EFLU-DES235', '18990-0000-235', '200200388',
        'Desionizador de agua', 'Barnstead', 'Megapure D2', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel A (Alto - Crítico)', 129.0, 83.33,
        'Obsolescencia Crítica', NULL, '',
        NULL, '', '',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-DES235", "nombre": "Desionizador de agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": 3.0, "io": 10.0, "fo": 4.0, "cm": 2.0, "sha": 1.0, "consecuencia": 43.0, "ic": 129.0, "categoria_criticidad": "Nivel A (Alto - Crítico)", "estatus_seleccion": "Selección Obligatoria (Pasa a Evaluación)", "criterio_accion": "Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-DES235", "nombre": "Desionizador de agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 3.0, "suma_puntos": 10.0, "iobs": 83.33, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "", "decision_sugerida_riesgo": "", "prioridad_oportunidad": "", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES235', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES235', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        236, 'INT-GAMB-EFLU-ANA236', '18010-0009-236', '-',
        'Analizador de Carbono Orgánico Total y Nitrógeno Total', 'Tekmar', 'Apollo 9000TM', 'US04190003',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        237, 'INT-GAMB-EFLU-BAL237', '18010-0025-237', '199800316',
        'Balanza de Precisión', 'Mettler', 'PB5001', '1117301085',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        238, 'INT-GAMB-EFLU-CEN238', '18010-0042-238', '200601493',
        'Centrífuga', 'Labnet', 'Z200A', '44060372',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        239, 'INT-GAMB-EFLU-MED239', '18010-0146-239', '200601487',
        'Medidor de flujo', 'Global Water', 'FP-201', '45709',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        240, 'INT-GAMB-EFLU-PLA240', '18010-0001-240', '199711037',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'NUOVA II', 'S18525', '30709271',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        241, 'INT-GAMB-EFLU-RAD241', '18990-0000-241', '200200736',
        'Radiómetro', 'VLX', '254', '05-13785',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        242, 'INT-GAMB-EFLU-DES242', '18010-0056-242', '200200404',
        'Desecador', 'SANPLATEC CORP.', 'Dry Keeper', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        243, 'INT-GAMB-EFLU-CÁM243', '18990-0000-243', '199800296',
        'Cámara digital', 'Sony', 'MVC-FD73', '177941',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        244, 'INT-GAMB-EFLU-BOM244', '18010-0032-244', '199711000',
        'Bomba peristáltica', 'Cole Parmer', '7523-10', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        245, 'INT-GAMB-EFLU-PLA245', '18010-0001-245', '199710961',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'Sin Información', 'SP47235-60', '612910909177',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        246, 'INT-GAMB-EFLU-PLA246', '18010-0001-246', '199710826',
        'Plancha de agitación', 'Corning', 'Sin Información', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        247, 'INT-GAMB-EFLU-PLA247', '18010-0001-247', '199711003',
        'Plancha de agitación', 'Cole Parmer', 'Sin Información', '233687',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        248, 'INT-GAMB-EFLU-BAÑ248', '18010-0027-248', '200200387',
        'Baño de agua', 'PRECISION', 'Sin información', '602051240',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        249, 'INT-GAMB-EFLU-MED249', '18010-0146-249', '200200338',
        'Medidor multiparámetro', 'HACH', 'SENSION 156', '20100001842',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        250, 'INT-GAMB-EFLU-MED250', '18010-0146-250', '199711043',
        'Medidor de ozono', 'OREC', 'DM-100', 'DM100-695',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        251, 'INT-GAMB-EFLU-MED251', '18010-0146-251', '200601774',
        'Medidor de Oxígeno Disuelto', 'YSY', '52CE', '04 M1081',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        252, 'INT-GAMB-EFLU-PLA252', '18010-0001-252', '199711003',
        'Plancha pequeña de agitación', 'Cole Parmer', 'Micro V', '233687',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        253, 'INT-GAMB-EFLU-BOM253', '18010-0032-253', '200100033',
        'Bomba peristáltica', 'Geopump', '900-1280', '604004652',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        254, 'INT-GAMB-EFLU-BOM254', '18010-0032-254', 'Sin Información',
        'Bomba de vacío', 'General electric', 'SKH3EKN90HX', '898',
        'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 13.0, 66.67,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-BOM254", "nombre": "Bomba de vacío", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": 1.0, "io": 5.0, "fo": 2.0, "cm": 2.0, "sha": 1.0, "consecuencia": 13.0, "ic": 13.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-BOM254", "nombre": "Bomba de vacío", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": 2.0, "rep": 2.0, "met": 2.0, "ant": 2.0, "suma_puntos": 8.0, "iobs": 66.67, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BOM254', 1.0, 5.0, 2.0, 2.0, 1.0, 13.0, 13.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BOM254', 2.0, 2.0, 2.0, 2.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        255, 'INT-GAMB-EFLU-EST255', '18010-0092-255', '200600961',
        'Estufa', 'Selecta', 'Digitheat', '502690',
        'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-EST255", "nombre": "Estufa", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-EST255", "nombre": "Estufa", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        256, 'INT-GAMB-EFLU-MED256', '18010-0146-256', '-',
        'Medidor de distribución de tamaño de partículas', 'MALVERN', 'MAF5000', 'MAL400167',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        257, 'INT-GAMB-EFLU-MED257', '18010-0146-257', '200600388',
        'Medidor de flujo', 'Dynasonics Ultrasonic Flowmeter', 'D904-A 1NA-NN', '37237',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        258, 'INT-GAMB-EFLU-MED258', '18010-0146-258', '-',
        'Medidor de oxígeno disuelto', 'YSY', '5000-115V', '06K1526',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        259, 'INT-GAMB-EFLU-TUR259', '18990-0000-259', '200602824',
        'Turbidímetro', 'HACH', '2100', '10030C026149',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        260, 'INT-GAMB-EFLU-BOM260', '18010-0032-260', '200200335',
        'Bomba de succión', 'SIEMENS', 'FE1500L', '11092',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        261, 'INT-GAMB-EFLU-PLA261', '18010-0001-261', '200602941',
        'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333759',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        262, 'INT-GAMB-EFLU-PLA262', '18010-0001-262', '200602939',
        'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333743',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        263, 'INT-GAMB-EFLU-PLA263', '18010-0001-263', '200602826',
        'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333749',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        264, 'INT-GAMB-EFLU-PLA264', '18010-0001-264', '199712284',
        'Plancha de agitación', 'Cole Parmer', '4805', '233721',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        265, 'INT-GAMB-EFLU-TER265', '18010-0217-265', '200604388',
        'Termohigrómetro', 'Extech', 'Sin Información', 'Q673621',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        266, 'INT-GAMB-EFLU-DES266', '18010-0058-266', '200604545',
        'Destilador kjeldahl automático', 'SELECTA', 'PN-1430', '471961',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        267, 'INT-GAMB-EFLU-DES267', '18010-0058-267', 'Sin Información',
        'Destilador kjeldahl automático', 'Gerhardt', 'vopdest 500', '5500260009',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-DES267", "nombre": "Destilador kjeldahl automático", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-DES267", "nombre": "Destilador kjeldahl automático", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        268, 'INT-GAMB-EFLU-EQU268', '18990-0000-268', '200604775',
        'Equipo de filtración a presión', 'Sin Información', 'Sin Información', 'S520773-1-002',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        269, 'INT-GAMB-EFLU-EQU269', '18990-0000-269', 'Sin Información',
        'Equipo de purificación de agua', 'Millipore', 'Gradient A10', 'F6JN70138B',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        270, 'INT-GAMB-EFLU-EQU270', '18990-0000-270', '199800588',
        'Equipo test jarra portátil', 'VELP', 'FPA N/P1011117', '1001271',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        271, 'INT-GAMB-EFLU-BAL271', '18010-0025-271', '20130556',
        'Balanza analítica', 'OHAUS', 'AV264C', 'B33470229',
        'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-BAL271", "nombre": "Balanza analítica", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-BAL271", "nombre": "Balanza analítica", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        272, 'INT-GAMB-EFLU-BAL272', '18010-0025-272', 'Sin Información',
        'Balanza analítica', 'Mettler Toledo', 'ABS204S', '1128222725',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        273, 'INT-GAMB-EFLU-EQU273', '18990-0000-273', '199711006',
        'Equipo test jarra portátil', 'VELP', 'FP4', '3970102',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        274, 'INT-GAMB-EFLU-GEN274', '18990-0000-274', 'Sin Información',
        'Generador de aire zero', 'PACKARD', '2500', '412711',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        275, 'INT-GAMB-EFLU-ESP275', '18010-0086-275', '199711034',
        'Espectrofotómetro portátil', 'HACH', 'DR/ 2010', '970500003241',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 22.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-ESP275", "nombre": "Espectrofotómetro portátil", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": 1.0, "io": 5.0, "fo": 4.0, "cm": 1.0, "sha": 1.0, "consecuencia": 22.0, "ic": 22.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-ESP275", "nombre": "Espectrofotómetro portátil", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": 1.0, "rep": 1.0, "met": 2.0, "ant": 3.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-ESP275', 1.0, 5.0, 4.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-ESP275', 1.0, 1.0, 2.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        276, 'INT-GAMB-EFLU-MED276', '18010-0145-276', '20131154',
        'medidor de ph', 'sensorex', 'sensolab pm 1000', 'pm 1000-0164',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-MED276", "nombre": "medidor de ph", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-MED276", "nombre": "medidor de ph", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        277, 'INT-GAMB-EFLU-INC277', '18010-0123-277', '199800042',
        'Incubador para equipo BOD', 'HACH', 'AR366KMVV', '970803043',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        278, 'INT-GAMB-EFLU-INC278', '18010-0123-278', '200601490',
        'Incubadora para BOD', 'Felisa', 'FE-145', '506134',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-INC278", "nombre": "Incubadora para BOD", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-INC278", "nombre": "Incubadora para BOD", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        279, 'INT-GAMB-EFLU-MUE279', '18990-0000-279', '200601491',
        'Muestreador automático', 'Masterflex', 'Sin Información', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'BAJA', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'BAJA', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        280, 'INT-GAMB-EFLU-MUF280', '18010-0158-280', '200604546',
        'Mufla', 'NABERTHERM', 'L 9/11/B170', '183443',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        281, 'INT-GAMB-EFLU-NEV281', '18010-0159-281', '200604386',
        'Nevera', 'Sin Información', 'Sin Información', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        282, 'INT-GAMB-EFLU-NEV282', '18010-0159-282', '20131155',
        'neverA', 'Samnsung', 'B00S9', 'Sin Información',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        283, 'INT-GAMB-EFLU-OZO283', '18990-0000-283', '200601513',
        'Ozonador', 'OREC', 'LAB21', '1420922',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        284, 'INT-GAMB-EFLU-REA284', '18990-0000-284', '199800001',
        'Reactor de DQO', 'HACH', '45600', '980400017495',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Sin Información',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-REA284", "nombre": "Reactor de DQO", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-REA284", "nombre": "Reactor de DQO", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        285, 'INT-GAMB-EFLU-REC285', '18010-0081-285', '200603561',
        'Recirculador de Agua', 'Selecta', 'Frigiterm', '549239',
        'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-REC285", "nombre": "Recirculador de Agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-REC285", "nombre": "Recirculador de Agua", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        286, 'INT-GAMB-EFLU-REC286', '18010-0081-286', '199711054',
        'Recirculador de agua', 'Neslab', 'RTE100', '194230068',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        287, 'INT-GAMB-EFLU-REC287', '18010-0081-287', '200602825',
        'Recirculador de agua', 'Thermo Scientific', 'HAAKE A28', '110154012',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        288, 'INT-GAMB-EFLU-TIT288', '18010-0156-288', '200601488',
        'Titulador automático con agitador', 'Methrom', '775 Dosimat', '10240945',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        289, 'INT-GAMB-EFLU-TIT289', '18010-0156-289', '200601489',
        'Titulador automático con agitador', 'Methrom', '775 Dosimat', '112140104',
        'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        290, 'INT-GAMB-EFLU-TIT290', '18010-0156-290', '200601489',
        'Titulador automático con agitador', 'Methrom', '775 Dosimat', '112140104',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        291, 'INT-GAMB-EFLU-TIT291', '18010-0156-291', '200601488',
        'Titulador automático con agitador', 'Methrom', '775 Dosimat', '10240905',
        'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        292, 'INT-GAMB-EFLU-TER292', '18010-0217-292', '200604389',
        'Termohigrómetro', 'Extech', 'SD700', 'Q673537',
        'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Alta', NULL, NULL,
        '', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-EFLU-TER292", "nombre": "Termohigrómetro", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "ff": null, "io": null, "fo": null, "cm": null, "sha": null, "consecuencia": null, "ic": null, "categoria_criticidad": "", "estatus_seleccion": "", "criterio_accion": ""}'::jsonb, '{"tag_pdvsa": "INT-GAMB-EFLU-TER292", "nombre": "Termohigrómetro", "laboratorio": "Efluentes (Tratabilidad de Efluentes)", "eol": null, "rep": null, "met": null, "ant": null, "suma_puntos": null, "iobs": null, "estatus_obsolescencia": ""}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Sin Decisión Asignada", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        293, 'INT-GAMB-EFLU-TIT293', '18010-0156-293', '200200091',
        'Titulador automático con agitador', 'METHROM', 'DOSIMAT 665', '16490030',
        'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        294, 'INT-GAMB-EFLU-ULT294', '18990-0000-294', '200600962',
        'Ultrasonido', 'Selecta', 'UB1488', '474073',
        'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        295, 'INT-GAMB-EFLU-ULT295', '18990-0000-295', '200600959',
        'Ultrasonido', 'Selecta', 'ULTRASONS', '3000910',
        'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        296, 'INT-GAMB-EFLU-UNI296', '18010-0063-296', '200604544',
        'Unidad de digestión', 'SELECTA', 'BLOC DIGEST 12', '464720',
        'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        297, 'INT-GAMB-QUÍM-ASP297', '18990-0000-297', '199711080',
        'Aspiradora', 'GOLDSTAR', 'V-2800TE', '701KB00198',
        'Química Ambiental', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        298, 'INT-GAMB-QUÍM-BAÑ298', '18990-0000-298', '19971103',
        'Baño de ultrasonido', 'COLE-PARMER', '8893', '8893-DTH',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        299, 'INT-GAMB-QUÍM-ANA299', '18010-0009-299', 'Sin Información',
        'Analizador de hidrocarburos', 'SITELAB', 'TD-3100', '31-0187',
        'Química Ambiental', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        300, 'INT-GAMB-QUÍM-ANA300', '18010-0009-300', '200603287',
        'Analizador de Mercurio', 'TELEDYNE LEEMAN LABS', 'Hydra II AA', '3091',
        'Química Ambiental', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 26.0, 50.0,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-ANA300", "nombre": "Analizador de Mercurio", "laboratorio": "Química Ambiental", "ff": 1.0, "io": 5.0, "fo": 4.0, "cm": 2.0, "sha": 4.0, "consecuencia": 26.0, "ic": 26.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-ANA300", "nombre": "Analizador de Mercurio", "laboratorio": "Química Ambiental", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 2.0, "suma_puntos": 6.0, "iobs": 50.0, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ANA300', 1.0, 5.0, 4.0, 2.0, 4.0, 26.0, 26.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ANA300', 1.0, 2.0, 1.0, 2.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        301, 'INT-GAMB-QUÍM-DES301', '18990-0000-301', 'Sin Información',
        'Desionizador de agua', 'BARNSTEAD', 'D2', '681931119331',
        'Química Ambiental', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        302, 'INT-GAMB-QUÍM-DES302', '18010-0058-302', 'Sin Información',
        'Destilador de agua', 'BARNSTEAD', 'MP-1', '798051222025',
        'Química Ambiental', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        303, 'INT-GAMB-QUÍM-EQU303', '18990-0000-303', '200200337',
        'Equipo de rodillos para cultivo', 'WHEATON', '348921UL', 'I01563',
        'Química Ambiental', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        304, 'INT-GAMB-QUÍM-ESP304', '18010-0087-304', '200601801',
        'Espectrómetro De Plasma (ICP-OES)', 'TELEDYNE LEEMAN LABS', 'PRODIGY', '8019',
        'Química Ambiental', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        305, 'INT-GAMB-QUÍM-ESP305', '18010-0086-305', 'Sin Información',
        'Espectofotometro', 'HACH', 'DR2800', '1179229',
        'Química Ambiental', 'ALTA', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'ALTA', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        306, 'INT-GAMB-QUÍM-ESP306', '18010-0086-306', 'Sin Información',
        'espectofotometro UV visible', 'Analytikjena', 'SPECORD 210 PLUS', '223F1729F',
        'Química Ambiental', 'Ata', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 12.0, 41.67,
        'Obsolescencia Baja', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-ESP306", "nombre": "espectofotometro UV visible", "laboratorio": "Química Ambiental", "ff": 1.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 12.0, "ic": 12.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-ESP306", "nombre": "espectofotometro UV visible", "laboratorio": "Química Ambiental", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 1.0, "suma_puntos": 5.0, "iobs": 41.67, "estatus_obsolescencia": "Obsolescencia Baja"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP306', 1.0, 5.0, 2.0, 1.0, 1.0, 12.0, 12.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP306', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        307, 'INT-GAMB-QUÍM-ESP307', '18010-0087-307', 'Sin Información',
        'Espectrómetro De Plasma (ICP-OES)', 'TELEDYNE LEEMAN LABS', 'PRODIGY', '3046',
        'Química Ambiental', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel B (Medio - Semicrítico)', 94.0, 75.0,
        'Obsolescencia Crítica', 6.25, 'Riesgo Alto',
        9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-ESP307", "nombre": "Espectrómetro De Plasma (ICP-OES)", "laboratorio": "Química Ambiental", "ff": 2.0, "io": 10.0, "fo": 4.0, "cm": 3.0, "sha": 4.0, "consecuencia": 47.0, "ic": 94.0, "categoria_criticidad": "Nivel B (Medio - Semicrítico)", "estatus_seleccion": "Selección Condicionada (Pasa a Evaluación)", "criterio_accion": "Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-ESP307", "nombre": "Espectrómetro De Plasma (ICP-OES)", "laboratorio": "Química Ambiental", "eol": 3.0, "rep": 3.0, "met": 1.0, "ant": 2.0, "suma_puntos": 9.0, "iobs": 75.0, "estatus_obsolescencia": "Obsolescencia Crítica"}'::jsonb, '{"cruce_resultado": "CRÍTICO EXTREMO", "decision_sugerida_riesgo": "Sustitución Inmediata", "prioridad_oportunidad": "Oportunidad Prioritaria", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP307', 2.0, 10.0, 4.0, 3.0, 4.0, 47.0, 94.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP307', 3.0, 3.0, 1.0, 2.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        308, 'INT-GAMB-QUÍM-IMP308', '18990-0000-308', 'Sin Información',
        'impresora', 'HP', 'deskjet 2875', 'BR45LBG1NF',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        309, 'INT-GAMB-QUÍM-MOL309', '18010-0155-309', '200601772',
        'Molino analítico', 'IKA-WERKE', 'M20', '03-269165',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        310, 'INT-GAMB-QUÍM-MON310', '18990-0000-310', 'Sin Información',
        'MONITOR', 'DELL', 'P2012Ht', 'CN-0W5HWR-74445-342-C4DS',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        311, 'INT-GAMB-QUÍM-MON311', '18990-0000-311', 'Sin Información',
        'MONITOR', 'DELL', 'P2012Ht', 'CN-0W5HWR-74445-312-A24L',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        312, 'INT-GAMB-QUÍM-MON312', '18990-0000-312', 'Sin Información',
        'monitor', 'HP', 'Sin Información', 'CNK4400P7C',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        313, 'INT-GAMB-QUÍM-MUF313', '18010-0158-313', '200200382',
        'Mufla de mesa', 'LINDBERG/BLUE', 'BF51828C-1', 'R18M-578553-RM',
        'Química Ambiental', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        314, 'INT-GAMB-QUÍM-NEB314', '18990-0000-314', 'Sin Información',
        'Nebulizador neumático', 'CETAC', 'MARIN-5', '071301MR5',
        'Química Ambiental', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        315, 'INT-GAMB-QUÍM-PC315', '18990-0000-315', 'Sin Información',
        'PC', 'DELL', 'OPTIPLEX 3010', '603DP60003G30131795VLA2',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        316, 'INT-GAMB-QUÍM-PC316', '18990-0000-316', 'Sin Información',
        'PC', 'DELL', 'OPTIPLEX 3010', '603DP60001G23314785VLA0',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        317, 'INT-GAMB-QUÍM-PC317', '18990-0000-317', 'Sin Información',
        'PC', 'INTEL CORE', 'Sin Información', '2MO421378J',
        'Química Ambiental', 'alta', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        318, 'INT-GAMB-QUÍM-PUR318', '18010-0096-318', 'Sin Información',
        'purificador de agua', 'MEMBRAPURE GmbH', 'AQUINITY P11', 'RW 250606',
        'Química Ambiental', 'media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        319, 'INT-GAMB-QUÍM-ANA319', '18010-0009-319', 'Sin Información',
        'Analizador de hidrocarburos', 'SITELAB', 'TD-3100', '31-0188',
        'Química Ambiental', 'media', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        320, 'INT-GAMB-QUÍM-BAL320', '18010-0025-320', 'Sin Información',
        'Balanza Analítica', 'OHAUS', 'PIONEER PA313', '8331140070',
        'Química Ambiental', 'media', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 24.0, 58.33,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-BAL320", "nombre": "Balanza Analítica", "laboratorio": "Química Ambiental", "ff": 2.0, "io": 5.0, "fo": 2.0, "cm": 1.0, "sha": 1.0, "consecuencia": 12.0, "ic": 24.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-BAL320", "nombre": "Balanza Analítica", "laboratorio": "Química Ambiental", "eol": 1.0, "rep": 3.0, "met": 1.0, "ant": 2.0, "suma_puntos": 7.0, "iobs": 58.33, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-BAL320', 2.0, 5.0, 2.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-BAL320', 1.0, 3.0, 1.0, 2.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        321, 'INT-GAMB-QUÍM-BAL321', '18010-0025-321', 'Sin Información',
        'Balanza Analítica', 'OHAUS', 'ADVENTURE PRO AV264C', '8031201114',
        'Química Ambiental', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        322, 'INT-GAMB-QUÍM-BAL322', '18010-0025-322', 'Sin Información',
        'Balanza electrónica', 'PRECISA', 'XB 6200D', '83132',
        'Química Ambiental', 'Baja', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        323, 'INT-GAMB-QUÍM-BAÑ323', '18010-0027-323', '200200384',
        'Baño termostático', 'FISHER SCIENTIFIC', 'ISOTEMP 215', '204N0055',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        324, 'INT-GAMB-QUÍM-CEN324', '18010-0042-324', 'Sin Información',
        'Centrífuga de mesa', 'FISHER SCIENTIFIC', '228', '1624060540269',
        'Química Ambiental', 'Baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        325, 'INT-GAMB-QUÍM-CON325', '18990-0000-325', '199711102',
        'Concentrador', 'ZYMARK', 'Turbo Vap II', '4020',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        326, 'INT-GAMB-QUÍM-PH 326', '18010-0145-326', 'Sin Información',
        'Ph metro / conductimetro', 'APERA Instument', 'PC 910', '1220361004',
        'Química Ambiental', 'alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 14.0, 41.67,
        'Obsolescencia Baja', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-PH 326", "nombre": "Ph metro / conductimetro", "laboratorio": "Química Ambiental", "ff": 2.0, "io": 5.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 7.0, "ic": 14.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-PH 326", "nombre": "Ph metro / conductimetro", "laboratorio": "Química Ambiental", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 1.0, "suma_puntos": 5.0, "iobs": 41.67, "estatus_obsolescencia": "Obsolescencia Baja"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-PH 326', 2.0, 5.0, 1.0, 1.0, 1.0, 7.0, 14.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-PH 326', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        327, 'INT-GAMB-QUÍM-SIS327', '18990-0000-327', '200604402',
        'Sistema de reacción asistida por microondas', 'CEM', 'MARSXPRESS', 'MD5056',
        'Química Ambiental', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        328, 'INT-GAMB-QUÍM-EST328', '18010-0092-328', '199711098',
        'Estufa', 'MEMMERT', '50', '810023',
        'Química Ambiental', 'media', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'media', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        329, 'INT-GAMB-QUÍM-SIS329', '18990-0000-329', '200100067',
        'Sistema de reacción asistida por microondas', 'CEM', 'MARS 5', 'MD7162',
        'Química Ambiental', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        330, 'INT-GAMB-QUÍM-PLA330', '18010-0001-330', 'Sin Información',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'FISHER SCIENTIFIC', 'ISOTEMP', 'C1892101142707',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        331, 'INT-GAMB-QUÍM-PLA331', '18010-0001-331', 'Sin Información',
        'PLANCHA DE AGITACION Y CALENTAMIENTO', 'THERMOLYNE', 'CIMAREC 3', '612911018012',
        'Química Ambiental', 'baja', 'Aparato Auxiliar',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'baja', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        332, 'INT-GAMB-QUÍM-ESP332', '18010-0086-332', '20130265',
        'Espectrofotómetro UV-VIS', 'AGILENT', 'Sin Información', '8453',
        'Química Ambiental', 'Sin Información', 'Sin Información',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Sin Información', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        333, 'INT-GAMB-QUÍM-TER333', '18010-0217-333', '200604399',
        'Termohigrómetro digital', 'Extech instrument', 'SD700', 'Q668937',
        'Química Ambiental', 'Alta', 'Instrumento de Medición',
        TRUE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'Nivel C (Bajo - No Crítico)', 28.0, 50.0,
        'Obsolescencia Media', NULL, NULL,
        NULL, NULL, 'RIESGOS NO EVALUADOS',
        '', '', NULL,
        '', '', NULL,
        '{"tag_pdvsa": "INT-GAMB-QUÍM-TER333", "nombre": "Termohigrómetro digital", "laboratorio": "Química Ambiental", "ff": 4.0, "io": 5.0, "fo": 1.0, "cm": 1.0, "sha": 1.0, "consecuencia": 7.0, "ic": 28.0, "categoria_criticidad": "Nivel C (Bajo - No Crítico)", "estatus_seleccion": "Exclusión (Mantenimiento Rutinario)", "criterio_accion": "No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico"}'::jsonb, '{"tag_pdvsa": "INT-GAMB-QUÍM-TER333", "nombre": "Termohigrómetro digital", "laboratorio": "Química Ambiental", "eol": 1.0, "rep": 2.0, "met": 1.0, "ant": 2.0, "suma_puntos": 6.0, "iobs": 50.0, "estatus_obsolescencia": "Obsolescencia Media"}'::jsonb, '{"cruce_resultado": "RIESGOS NO EVALUADOS", "decision_sugerida_riesgo": "Gestión por Mantenimiento Rutinario", "prioridad_oportunidad": "OPORTUNIDADES NO EVALUADAS", "decision_sugerida_oportunidad": "N/A", "decision_estrategica_final": "", "responsable_de": "", "fecha_de": null, "decision_operativa": "", "responsable_do": "", "fecha_do": null}'::jsonb
    ) RETURNING id INTO v_act_id;
    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-TER333', 4.0, 5.0, 1.0, 1.0, 1.0, 7.0, 28.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-TER333', 1.0, 2.0, 1.0, 2.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        334, 'INT-GAMB-QUÍM-TER334', '18010-0217-334', 'Sin Información',
        'Termohigrómetro digital', 'Extech instrument', 'SD700', 'Q668939',
        'Química Ambiental', 'alta', 'Instrumento de Medición',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'alta', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        335, 'INT-GAMB--UFU335', '18010-0205-335', 'ufuf',
        'ufutfut', 'Sin Información', 'Sin Información', 'Sin Información',
        'Gerencia de Ambiente', '', '',
        FALSE, 'Operativo', 'PDVSA INTEVEP S.A.', 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
        'Gerencia de Ambiente', 'No Evaluado', NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        NULL, NULL, NULL,
        '{}'::jsonb, '{}'::jsonb, NULL
    ) RETURNING id INTO v_act_id;
END $$;

-- 9. INSERTAR REGISTROS DE CALIBRACIÓN METROLÓGICA (ISO 10012)

INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-GCMS-001', 'CAL-2026-001', 'CERT-MET-2026-884',
    '2026-06-15', '2027-06-15', 223,
    'VIGENTE', 'SENCAMER / Lab. Metrología Acreditado ISO 17025', 'Escala de Masa Cuadrupolo (m/z) y Temp. Horno',
    '+0.03 u / +0.3 °C', 'U = ± 0.05 u (k=2, 95%)', 'MEP: ± 0.10 u / ± 1.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-01', 'Ing. Carlos Mendoza (Metrólogo Sr.)',
    'Confirmación metrológica satisfactoria. Precinto de seguridad colocado. Apto para ensayos de efluentes.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-GCMS-001', 'CAL-2025-001', 'CERT-MET-2025-612',
    '2025-06-10', '2026-06-10', -147,
    'VENCIDA', 'SENCAMER / Lab. Metrología Acreditado ISO 17025', 'Escala de Masa Cuadrupolo (m/z) y Temp. Horno',
    '-0.04 u / +0.4 °C', 'U = ± 0.05 u (k=2, 95%)', 'MEP: ± 0.10 u / ± 1.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2025-04', 'Ing. Carlos Mendoza (Metrólogo Sr.)',
    'Calibración reglamentaria. Ajuste leve de ganancia del detector EM. Conforme.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-GCMS-001', 'CAL-2024-001', 'CERT-MET-2024-409',
    '2024-06-12', '2025-06-12', -510,
    'VENCIDA', 'Agilent Technologies Metrology Lab', 'Escala de Masa Cuadrupolo (m/z) y Temp. Horno',
    '+0.02 u / +0.2 °C', 'U = ± 0.05 u (k=2, 95%)', 'MEP: ± 0.10 u / ± 1.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2024-02', 'Ing. Reinaldo Peña (Especialista Metrología)',
    'Calibración periódica satisfactoria sin desviaciones. Trazabilidad NIST.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-GCMS-001', 'CAL-2023-001', 'CERT-MET-2023-288',
    '2023-06-15', '2024-06-15', -872,
    'VENCIDA', 'SENCAMER / Agilent Technologies', 'Escala de Masa Cuadrupolo (m/z) y Temp. Horno',
    '+0.03 u / -0.3 °C', 'U = ± 0.05 u (k=2, 95%)', 'MEP: ± 0.10 u / ± 1.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2023-01', 'Ing. Carlos Mendoza (Metrólogo Sr.)',
    'Calibración anual completada tras mantenimiento mayor preventivo.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-GCMS-001', 'CAL-2021-001', 'CERT-MET-2021-098',
    '2021-03-25', '2022-03-25', -1685,
    'VENCIDA', 'Agilent Technologies Factory / SENCAMER', 'Calificación Inicial de Instalación y Operación (IQ/OQ/PQ)',
    '0.00 u / +0.1 °C', 'U = ± 0.04 u (k=2, 95%)', 'MEP: ± 0.10 u / ± 1.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2021-01', 'Ing. Klaus Weber (Servicio Autorizado)',
    'Puesta en marcha y calificación inicial satisfactoria según protocolo IQ/OQ/PQ.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-UVVIS-002', 'CAL-2026-002', 'CERT-MET-2026-902',
    '2026-05-10', '2027-05-10', 187,
    'VIGENTE', 'SENCAMER / Lab. Metrología Acreditado ISO 17025', 'Exactitud Longitud de Onda y Fotometría UV-Vis',
    '+0.001 A / +0.05 nm', 'U = ± 0.002 A (k=2, 95%)', 'MEP: ± 0.003 A / ± 0.1 nm',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-04', 'Ing. Carlos Mendoza (Metrólogo Sr.)',
    'Calibración anual conforme con filtros certificados de óxido de holmio y densidad óptica neutral.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-AAS-003', 'CAL-2026-003', 'CERT-MET-2026-915',
    '2026-04-18', '2027-04-18', 165,
    'VIGENTE', 'Thermo Scientific / SENCAMER Acreditado', 'Absorbancia en Llama y Temperatura Horno Grafito',
    '-0.002 A / +1.2 °C', 'U = ± 0.004 A (k=2, 95%)', 'MEP: ± 0.005 A / ± 2.0 °C',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-07', 'Ing. Reinaldo Peña (Especialista Metrología)',
    'Verificación de linealidad fotométrica y control de temperatura de atomización conformes.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-BAL-004', 'CAL-2026-004', 'CERT-MET-2026-930',
    '2026-07-20', '2027-01-20', 77,
    'VIGENTE', 'SENCAMER Lab. Nacional de Metrología (Masa)', 'Carga, Excentricidad y Repetibilidad (Pesas Clase E2)',
    '+0.02 mg', 'U = ± 0.03 mg (k=2, 95%)', 'MEP: ± 0.10 mg',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-11', 'Metr. Sonia Rivas (Metrólogo Sr.)',
    'Calibración semestral conforme. Clase de exactitud I (Especial). Errores dentro de tolerancias.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-TOC-005', 'CAL-2026-005', 'CERT-MET-2026-942',
    '2026-08-15', '2027-08-15', 284,
    'VIGENTE', 'Shimadzu Metrology / SENCAMER Acreditado', 'Concentración Carbono Total (TC/IC) Detector NDIR',
    '+0.08 mg/L', 'U = ± 0.12 mg/L (k=2, 95%)', 'MEP: ± 0.20 mg/L',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-15', 'Ing. Carlos Mendoza (Metrólogo Sr.)',
    'Calibración del sistema NDIR y linealidad de combustión catalítica a 680 °C satisfactorias.'
);
INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    'AMB-LAB-PH-006', 'CAL-2026-006', 'CERT-MET-2026-955',
    '2026-09-01', '2027-03-01', 117,
    'VIGENTE', 'SENCAMER / Laboratorio de Metrología INTEVEP', 'Potencial de Celda (pH) y Conductividad Electrolítica',
    '+0.005 pH / +0.2 µS/cm', 'U = ± 0.010 pH (k=2, 95%)', 'MEP: ± 0.020 pH / ± 0.5%',
    'Conforme (Pasa)', 'PDVSA-CAL-2026-19', 'Lic. Andrea Briceño (Especialista)',
    'Calibración electroquímica con tampones certificados trazables NIST. Pendiente electrodo 99.4%.'
);

-- 10. INSERTAR MANTENIMIENTOS PDVSA (FO-008)

INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-GCMS-001', 'OT-PDVSA-2026-018', 'Preventivo Planificado Sistemático',
    'PM-LAB-GCMS-TRIM', '2026-09-10', '2026-09-11',
    'Mantenimiento preventivo trimestral: Limpieza de puerto inyector Split/Splitless, reemplazo de septa e inserto ultra inerte, verificación de estanqueidad de helio y prueba de fugas electrónicas.', 'Septa de silicona alta temperatura, Ultra Inert Split Liner con lana desactivada, sello de oro base inyector', 12.0,
    480.0, 'Téc. Marcos Rivas (INTEVEP Mant.)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2026-12-11'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-GCMS-001', 'OT-PDVSA-2026-009', 'Preventivo Planificado Sistemático',
    'PM-LAB-GCMS-ANUAL', '2026-06-12', '2026-06-14',
    'Mantenimiento anual mayor: Desmontaje y limpieza de fuente de iones EI, cambio de aceite de bomba rotatoria de previo vacío, reemplazo de trampas de gases y ajuste de espectrómetro MSD.', 'Aceite sintético para bomba Edwards, kit universal trampas de He/O2, filamento EI tungsteno, empaquetaduras de oro', 28.0,
    2150.0, 'Ing. Carlos Mendoza / Agilent Tech', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2027-06-14'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-GCMS-001', 'OT-PDVSA-2026-004', 'Preventivo Planificado Sistemático',
    'PM-LAB-GCMS-TRIM', '2026-03-20', '2026-03-21',
    'Mantenimiento trimestral: Reemplazo preventivo de septa, limpieza ultrasónica de liner, ajuste de flujo de gas portador EPC y prueba de línea base con autotune de verificación.', 'Septa de silicona desgasificada, O-ring de fluoroelastómero inyector', 10.0,
    420.0, 'Téc. Marcos Rivas (INTEVEP Mant.)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2026-06-21'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-GCMS-001', 'OT-PDVSA-2025-045', 'Correctivo Programado',
    'CORR-LAB-GCMS-01', '2025-11-15', '2025-11-16',
    'Reemplazo de filamento 1 por advertencia de emisión de electrones baja. Ajuste de voltaje de lentes de enfoque y verificación de espectro PFTBA. Sin daño a muestras.', 'Filamento MSD Agilent G7005-60061 original, sellos de vacío Viton', 8.0,
    650.0, 'Ing. Reinaldo Peña (Especialista)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2026-02-16'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-UVVIS-002', 'OT-PDVSA-2026-022', 'Preventivo Planificado Sistemático',
    'PM-LAB-UVVIS-SEM', '2026-08-14', '2026-08-15',
    'Mantenimiento preventivo semestral: Limpieza óptica de espejos, verificación alineación lámpara deuterio y prueba de estabilidad de línea base fotométrica.', 'Lámpara de deuterio de repuesto, desecante óptico de sílice', 8.0,
    320.0, 'Téc. Marcos Rivas (INTEVEP Mant.)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2027-02-15'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-AAS-003', 'OT-PDVSA-2026-015', 'Preventivo Planificado Sistemático',
    'PM-LAB-AAS-SEM', '2026-07-10', '2026-07-12',
    'Mantenimiento semestral: Limpieza de cámara de nebulización y quemador de titanio, reemplazo de tubos de grafito con plataforma L''vov y calibración de flujo de gases.', 'Tubo grafito pirolítico, O-rings de teflón para nebulizador', 14.0,
    890.0, 'Ing. Carlos Mendoza / Thermo Service', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2027-01-12'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-BAL-004', 'OT-PDVSA-2026-011', 'Preventivo y Limpieza Metrológica',
    'PM-LAB-BAL-SEM', '2026-06-05', '2026-06-05',
    'Limpieza exhaustiva de platillo de carga, cortavientos de vidrio y calibración interna automatizada proFACT por variación de temperatura.', 'Pincel antiestático, paños ópticos sin pelusa', 4.0,
    150.0, 'Metr. Sonia Rivas (Metrólogo Sr.)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2026-12-05'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-TOC-005', 'OT-PDVSA-2026-019', 'Preventivo Planificado Sistemático',
    'PM-LAB-TOC-SEM', '2026-09-18', '2026-09-19',
    'Regeneración de catalizador de platino, cambio de tubo de combustión de cuarzo y purga de trampas de halógenos y humedad.', 'Tubo de combustión cuarzo, empaque catalizador Pt, lana cuarzo', 10.0,
    540.0, 'Téc. Marcos Rivas (INTEVEP Mant.)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2027-03-19'
);
INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    'AMB-LAB-PH-006', 'OT-PDVSA-2026-008', 'Preventivo y Sustitución de Sensores',
    'PM-LAB-PH-ANUAL', '2026-05-22', '2026-05-22',
    'Reacondicionamiento de unión cerámica de electrodo ROSS Ultra, recarga de solución electrolito 3M KCl y verificación de pendiente operacional.', 'Solución de llenado Orion 810007, juego tampones pH', 3.0,
    95.0, 'Lic. Andrea Briceño (Especialista)', 'Sin Impacto (Ensayos Previos Válidos)',
    FALSE, 'Cerrada / Completada', 'Dra. Elena Salazar',
    '2027-05-22'
);

-- 11. INSERTAR COMPROBACIONES INTERMEDIAS (ISO 17025)

INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-GCMS-001', 'CI-2026-010', '2026-10-02',
    'Sintonización MSD Autotune (Relación Abundancia Masa m/z 502/69 %)', 0, 0.8,
    5.0, 2.45, 'CONFORME (PASA)',
    '-0.45', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-GCMS-001', 'CI-2026-009', '2026-09-05',
    'Repetibilidad de Tiempo de Retención RT - Pico Fenantreno (min)', 0, 12.44,
    12.52, 12.48, 'CONFORME (PASA)',
    '0', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-GCMS-001', 'CI-2026-008', '2026-08-03',
    'Sensibilidad / Relación Señal-Ruido S/N (OFN m/z 272)', 0, 1500.0,
    9999.0, 3820.0, 'CONFORME (PASA)',
    '-1929.5', 'ETIQUETA VERDE - EN SERVICIO', 'Ing. Reinaldo Peña'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-GCMS-001', 'CI-2026-007', '2026-07-02',
    'Estabilidad de Línea Base y Hermeticidad (Flujo He ml/min)', 0, 1.15,
    1.25, 1.2, 'CONFORME (PASA)',
    '0', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-UVVIS-002', 'CI-2026-011', '2026-10-05',
    'Verificación de Exactitud Fotométrica y Longitud de Onda (Filtro Óxido de Holmio 361 nm)', 0, 360.8,
    361.2, 361.02, 'CONFORME (PASA)',
    '0.02', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-AAS-003', 'CI-2026-012', '2026-09-28',
    'Sensibilidad y Absorbancia Cobre 5 ppm en Llama Aire-Acetileno', 0, 0.45,
    0.55, 0.505, 'CONFORME (PASA)',
    '5.0000000000000001E-3', 'ETIQUETA VERDE - EN SERVICIO', 'Ing. Reinaldo Peña'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-BAL-004', 'CI-2026-013', '2026-10-14',
    'Verificación de Repetibilidad y Carga con Pesa Patrón 100 g Clase E2', 0, 99.9998,
    100.0002, 100.0, 'CONFORME (PASA)',
    '0', 'ETIQUETA VERDE - EN SERVICIO', 'Metr. Sonia Rivas'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-TOC-005', 'CI-2026-014', '2026-10-08',
    'Control de Verificación Estándar Carbono Total TC 10.0 mg/L', 0, 9.7,
    10.3, 9.95, 'CONFORME (PASA)',
    '-0.05', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);
INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    'AMB-LAB-PH-006', 'CI-2026-015', '2026-10-18',
    'Pendiente de Calibración Slope y Lectura Tampón pH 7.00', 0, 6.98,
    7.02, 7.01, 'CONFORME (PASA)',
    '0.01', 'ETIQUETA VERDE - EN SERVICIO', 'Lic. Andrea Briceño'
);

-- 12. INSERTAR DERIVA METROLÓGICA (FO-018)


-- 13. INSERTAR CONTROL PATRIMONIAL SUDEBIP Y DEPRECIACIÓN

INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'Tag Técnico PDVSA', 'Código Patrimonial SIGEBI', 0,
    'Fecha de Incorporación', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-GCMS-001', 'BP-INT-2021-00452', 0,
    '2021-01-15', 85000.0, 0.1,
    8500.0, 76500, 10,
    69.0, 637.5, 43987.5
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-UVVIS-002', 'BP-INT-2022-00118', 0,
    '2022-03-10', 22000.0, 0.1,
    2200.0, 19800, 8,
    55.0, 206.25, 11343.75
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-AAS-003', 'BP-INT-2020-00891', 0,
    '2020-11-05', 68000.0, 0.1,
    6800.0, 61200, 10,
    71.0, 510.0, 36210.0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-BAL-004', 'BP-INT-2023-00034', 0,
    '2023-04-20', 12500.0, 0.05,
    625.0, 11875, 8,
    42.0, 123.69791666666667, 5195.3125
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-TOC-005', 'BP-INT-2022-00572', 0,
    '2022-08-14', 34000.0, 0.1,
    3400.0, 30600, 8,
    50.0, 318.75, 15937.5
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-PH-006', 'BP-INT-2023-00201', 0,
    '2023-09-12', 4800.0, 0.05,
    240.0, 4560, 5,
    37.0, 76.0, 2812.0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'TABLA 5B: HISTORIAL DE MOVIMIENTOS, TRANSFERENCIAS Y ASIGNACIONES PATRIMONIALES (SUDEBIP / LOBP)', '', 0,
    NULL, 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'Tag Técnico PDVSA', 'N° Acta Movimiento', 0,
    'Tipo de Movimiento SUDEBIP', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-GCMS-001', 'ACTA-SUDEBIP-2021-014', 44270.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-GCMS-001', 'ACTA-SUDEBIP-2021-022', 44280.0,
    'Asignación de Custodia a Responsable', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-GCMS-001', 'ACTA-SUDEBIP-2023-089', 44942.0,
    'Salida Temporal para Calibración/Mantenimiento Externo', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-UVVIS-002', 'ACTA-SUDEBIP-2022-008', 44656.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-AAS-003', 'ACTA-SUDEBIP-2020-029', 44166.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-BAL-004', 'ACTA-SUDEBIP-2023-005', 45048.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-TOC-005', 'ACTA-SUDEBIP-2022-021', 44805.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);
INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    'AMB-LAB-PH-006', 'ACTA-SUDEBIP-2023-018', 45189.0,
    'Incorporación Inicial por Compra', 0.1, 0,
    0, 10, 0,
    0, 0, 0
);

-- 14. INSERTAR KPIS SGA (FO-017)

INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    1, 'PDVSA INTEVEP - GERENCIA DE AMBIENTE | SISTEMA DE GESTIÓN DE ACTIVOS (ISO 55001:2024)', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    2, 'FORMATO AMB-GEN-SGA-FO-022: INFORME TRIMESTRAL DE DESEMPEÑO DEL SGA', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    3, 'Período Evaluado:', 'Trimestre Q3 2026 (Julio - Septiembre)',
    'Código Formato:', 'AMB-GEN-SGA-FO-017', 'Fecha de Emisión:',
    '46310', 0, 'Versión:'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    4, 'Organización:', 'PDVSA INTEVEP, S.A.',
    'Sede:', 'El Tambor, Los Teques, Edo. Miranda', 'Área Operativa:',
    'Gerencia de Ambiente (GAMB)', 0, 'Procedimiento:'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    5, 'Coordinador SGA:', 'Ing. Carlos Mendoza (GAMB)',
    'Comité Gestión:', 'Comité Técnico Colegiado GAMB', 'Gerente Ambiente:',
    'Dr. Roberto Valenzuela (Aprobador)', 0, 'Vigencia:'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    6, 'Alcance del Informe:', 'Evaluación integral de desempeño, disponibilidad analítica, integridad metrológica y conciliación patrimonial de los 334 activos de la GAMB.',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    7, 'TOTAL ACTIVOS FÍSICOS', '',
    'ACTIVOS CRÍTICOS VITALES', '', 'DISPONIBILIDAD ANALÍTICA',
    '', 0, 'CONCILIACIÓN SUDEBIP'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    8, '334', '',
    '67', '', '0.82099999999999995',
    '', 0.912, '0.91200000000000003'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    9, 'Tangibles GAMB en Inventario', '',
    'Categoría A (Matriz MM-02-01-01)', '', 'Meta: >= 75.0% (Superada)',
    '', 0, 'Meta: 100.0% (En Regularización)'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    10, 'Patrimonio Registrado', '',
    'Portafolio Vital Prioritario', '', 'Operatividad Promedio GAMB',
    '', 0, 'Cotejo Físico / SAP / SUDEBIP'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    11, 'TABLERO DE CONTROL - 9 INDICADORES CLAVE DE DESEMPEÑO DEL SGA (AMB-GEN-SGA-PG-005)', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    12, 'N°', 'Indicador Clave de Desempeño (KPI)',
    'Dimensión', 'Fórmula de Cálculo', 'Meta',
    'Frecuencia', 0, 'Responsable'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    13, '1', 'Índice de Equipos Codificados e Inventariados',
    'Transición', 'NEIE / NTE * 100', '1',
    'Semestral', 0, 'Resp. Laboratorio'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    14, '2', 'Hojas de Vida Habilitadas (CHVH)',
    'Transición', 'HVA / TEL * 100', '1',
    'Mensual', 0, 'Resp. Laboratorio'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    15, '3', 'Cumplimiento Procedimental del SGA',
    'Transición', 'PEA / TPP * 100', '>= 90.0%',
    'Trimestral', 0, 'Coord. SGA'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    16, '4', 'Disponibilidad Analítica de Equipos Críticos (DA)',
    'Operativa', 'NES / NTE * 100', '>= 75.0%',
    'Trimestral', 0, 'Coord. SGA / Resp. Lab'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    17, '5', 'Obsolescencia Promedio Portafolio Vital (Iobs)',
    'Sostenibilidad', '(1/67) * SUM(Iobs_i)', '<= 40.0%',
    'Semestral', 0, 'Comité Gestión Activos'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    18, '6', 'Cumplimiento Plan Calibración y Mantenimiento (PCCMP)',
    'Operativa', 'MCE / MCP * 100', '>= 75.0%',
    'Semestral', 0, 'Resp. Laboratorio'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    19, '7', 'Conciliación Patrimonial Tripartita (SUDEBIP/SAP)',
    'Legal', 'ACEI / TEI * 100', '1',
    'Anual', 0, 'Resp. Lab / Custodio'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    20, '8', 'Cumplimiento Metas del PEGA (PC PEGA)',
    'Transición', 'Pond. PEGA / TMPEGA', '>= 85.0%',
    'Semestral/Anual', 0, 'Gerente AMB / Coord SGA'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    21, '9', 'Nivel de Madurez Organizacional IAM',
    'Madurez', 'Escala HDIM-CL (0 - 5)', '>= 1.0 (Consciente)',
    'Anual', 0, 'Comité Gestión Activos'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    22, 'RESUMEN', 'Eficacia Global del Sistema de Gestión de Activos',
    'Global', 'KPIs Conformes / Total', '>= 80.0%',
    'Trimestral', 0, 'Gerente de Ambiente'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    23, 'EVALUACIÓN DEL DESEMPEÑO ANALÍTICO POR LABORATORIO DE ENSAYO (SEDE EL TAMBOR)', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    24, 'N°', 'Laboratorio de Ensayo (GAMB)',
    'N° Equipos', 'Equipos Críticos (Cat A)', 'Disponibilidad Analítica (%)',
    'Calibración Vigente (%)', 0, 'Mantenimiento al Día (%)'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    25, '1', 'Lab. Fisicoquímica y Calidad de Aguas',
    '72', '14', '0.85199999999999998',
    '0.92500000000000004', 0.88, '0.88'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    26, '2', 'Lab. de Cromatografía y Compuestos Orgánicos',
    '58', '16', '0.79500000000000004',
    '0.81', 0.75, '0.75'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    27, '3', 'Lab. de Metales Pesados y Toxicología',
    '46', '11', '0.76800000000000002',
    '0.73', 0.71, '0.71'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    28, '4', 'Lab. de Calidad de Aire y Emisiones',
    '52', '9', '0.84',
    '0.89', 0.82, '0.82'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    29, '5', 'Lab. de Suelos y Lodos de Perforación',
    '65', '10', '0.86499999999999999',
    '0.9', 0.87, '0.87'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    30, '6', 'Lab. de Ecotoxicología y Bioensayos',
    '41', '7', '0.81',
    '0.85', 0.8, '0.8'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    31, 'TOTAL', 'Consolidado Gerencia de Ambiente',
    '334', '67', '0.82166666666666666',
    '0.85083333333333322', 0.8049999999999998, '0.80499999999999983'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    32, 'ANÁLISIS TÉCNICO DE DESVIACIONES, JUSTIFICACIONES Y ACCIONES INMEDIATAS', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    33, '1. Conciliación Patrimonial SUDEBIP (91.2%) y Codificación (94.6%): Existen 18 equipos con discrepancias físicas de chapa vs número en SAP PM. Se activó la acción correctiva PCB-2026-03 del Plan de Cierre de Brechas (FO-030) con plazo perentorio a 60 días para completar el 100%.', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    34, '2. Lab. de Metales Pesados (Calibración 73.0% y Mantenimiento 71.0%): Retraso en suministro de estándares certificados para ICP-OES. Se autorizó la adquisición prioritaria mediante caja chica técnica y ajuste de curva predictiva según FO-018 para no comprometer los resultados analíticos oficiales.', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    35, 'RESPONSABILIDAD Y FIRMAS DE APROBACIÓN INSTITUCIONAL', '',
    '', '', '',
    '', 0, ''
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    36, 'Elaborado por:', '',
    '', 'Revisado por:', '',
    '', 0, 'Aprobado por:'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    37, 'Ing. Carlos Mendoza (Coordinador SGA - GAMB)', '',
    '', 'Comité Técnico Colegiado de Gestión de Activos', '',
    '', 0, 'Dr. Roberto Valenzuela (Gerente de Ambiente INTEVEP)'
);
INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    38, 'Firma / Fecha: 15/10/2026', '',
    '', 'Firma / Fecha: 18/10/2026', '',
    '', 0, 'Firma / Fecha: 20/10/2026'
);

-- ==============================================================================
-- 15. VERIFICACIÓN FINAL DE CONTEOS
-- ==============================================================================
SELECT 
    (SELECT COUNT(*) FROM activos) AS total_activos,
    (SELECT COUNT(*) FROM activos WHERE pareto_20 = TRUE) AS total_pareto_20,
    (SELECT COUNT(*) FROM catalogo_sudebip) AS total_catalogo_sudebip,
    (SELECT COUNT(*) FROM jerarquizacion_criticidad) AS total_jerarquizacion,
    (SELECT COUNT(*) FROM evaluacion_obsolescencia) AS total_obsolescencia,
    (SELECT COUNT(*) FROM decisiones_estrategicas) AS total_decisiones;
