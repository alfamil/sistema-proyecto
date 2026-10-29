-- ========================================================================
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
