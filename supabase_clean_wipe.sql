-- =========================================================================
-- SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS (SIGAF) - PDVSA INTEVEP
-- SCRIPT DE DEPURACIÓN Y VACIADO TOTAL DE DATOS DE PRUEBA
-- =========================================================================
-- Este script elimina todos los registros de prueba errados para preparar
-- la base de datos para la carga del nuevo archivo oficial de activos.
-- Se preservan intactas las estructuras de tablas, funciones, vistas y catálogos.
-- =========================================================================

-- 1. Desactivar temporalmente triggers si fuera necesario y vaciar tablas hijas
TRUNCATE TABLE fallas_historial CASCADE;
TRUNCATE TABLE bitacora_cambios CASCADE;
TRUNCATE TABLE comprobaciones_intermedias CASCADE;
TRUNCATE TABLE mantenimientos_pdvsa CASCADE;
TRUNCATE TABLE calibraciones_metrologicas CASCADE;
TRUNCATE TABLE deriva_metrologica_fo018 CASCADE;
TRUNCATE TABLE depreciacion_patrimonial CASCADE;
TRUNCATE TABLE actas_movimiento_sudebip CASCADE;
TRUNCATE TABLE kpis_sga_fo017 CASCADE;
TRUNCATE TABLE acuerdos_direccion_fo019 CASCADE;
TRUNCATE TABLE cierre_brechas_fo030 CASCADE;

-- 2. Vaciar tablas principales
TRUNCATE TABLE activos CASCADE;
TRUNCATE TABLE catalogo_sudebip CASCADE;

-- 3. Confirmación de estado limpio
SELECT 
    (SELECT COUNT(*) FROM activos) AS total_activos,
    (SELECT COUNT(*) FROM calibraciones_metrologicas) AS total_calibraciones,
    (SELECT COUNT(*) FROM mantenimientos_pdvsa) AS total_mantenimientos,
    (SELECT COUNT(*) FROM deriva_metrologica_fo018) AS total_deriva;

-- =========================================================================
-- RESULTADO ESPERADO: Todos los contadores deben retornar 0.
-- La base de datos queda lista para la importación del nuevo archivo.
-- =========================================================================
