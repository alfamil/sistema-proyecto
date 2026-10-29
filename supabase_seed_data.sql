-- ========================================================================
-- SEED DATA: SISTEMA DE GESTIÓN DE ACTIVOS FÍSICOS (SGAF)
-- Datos extraídos de la herramienta oficial PDVSA INTEVEP / SUDEBIP
-- ========================================================================

-- 1. Catálogo SUDEBIP
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

-- 2. Activos, Jerarquización, Obsolescencia y Decisiones
DO $$
DECLARE
    v_act_id UUID;
BEGIN

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (1.0, 'INT-GAMB-AIRE-ANA01', '18010-0009-1', '199711198', 'ANALIZADOR DE O3', 'THERMO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (2.0, 'INT-GAMB-AIRE-ANA02', '18010-0009-2', '199711272', 'ANALIZADOR DE O3', 'THERMO', '49C', '49C-59563323', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 3.0, 10.0, 2.0, 1.0, 4.0, 25.0, 75.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA02', 2.0, 'Riesgo Bajo', 6.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA', 'Reemplazo Planificado a Mediano Plazo', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', 'Inclusión en Plan de Renovación Tecnológica', 'Responsable de Laboratorio', '2027-08-01', 'Mantenimiento Estándar Correr a la Falla (Run-to-Failure)', 'Analista de Gestióon de Calidad', '2026-10-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (3.0, 'INT-GAMB-AIRE-ANA03', '18010-0009-3', '199700011', 'ANALIZADOR DE O3', 'THERMO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (4.0, 'INT-GAMB-AIRE-AIR04', '18990-0000-4', '20120109', 'AIRE ZERO', 'INNOTEC', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (5.0, 'INT-GAMB-AIRE-AUT05', '18990-0000-5', '199712647', 'Autosampler Canisters', 'Entech', '7016', '2156634', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (6.0, 'INT-GAMB-AIRE-ANA06', '18010-0009-6', '200200712', 'ANALIZADOR DE CO', 'horiba', 'Sin Información', '42890430012', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (7.0, 'INT-GAMB-AIRE-ANA07', '18010-0009-7', '199711281', 'ANALIZADOR DE CO', 'HORIBA', 'Sin Información', '159454', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (8.0, 'INT-GAMB-AIRE-ANA08', '18010-0009-8', '199712973', 'ANALIZADOR DE CO', 'THERMO', 'Sin Información', '110001-438', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (9.0, 'INT-GAMB-AIRE-ANA09', '18010-0009-9', '199800013', 'ANALIZADOR DE CO', 'THERMO', 'Sin Información', 'M9000403', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (10.0, 'INT-GAMB-AIRE-BET10', '18990-0000-10', '199713277', 'BETA GAUS', 'TERMO', 'Sin Información', '665', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (11.0, 'INT-GAMB-AIRE-ANA11', '18010-0009-11', '199713208', 'ANALIZADOR DE CO', 'MONITOR LAB', 'Sin Información', '214803', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (12.0, 'INT-GAMB-AIRE-BET12', '18990-0000-12', '199713276', 'BETA GAUS', 'TERMO', 'Sin Información', '85332-241', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (13.0, 'INT-GAMB-AIRE-ANA13', '18010-0009-13', '199711220', 'ANALIZADOR DE CO', 'MONITOR LAB', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (14.0, 'INT-GAMB-AIRE-CAL14', '18990-0000-14', '199711184', 'Calibrador Primario', 'GRASEBY', 'Sin Información', 'PTS23032009', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (15.0, 'INT-GAMB-AIRE-CAL15', '18990-0000-15', '199711172', 'CALIBRADOR PRIMARIO DE O3', 'TERMO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Patrón de Medida', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (16.0, 'INT-GAMB-AIRE-CAN16', '18990-0000-16', '199713200', 'Canister de Acero Inoxidable', 'Graseby', 'AP27106', 'Sin Información', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (17.0, 'INT-GAMB-AIRE-CAR17', '18990-0000-17', 'Sin Información', 'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (18.0, 'INT-GAMB-AIRE-ANA18', '18010-0009-18', '199711283', 'ANALIZADOR DE H2S', 'horiba', 'Sin Información', '57690901', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA18', 3.0, 5.0, 2.0, 1.0, 1.0, 12.0, 36.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos y oportunidades; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA18', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA18', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, '2026-11-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (19.0, 'INT-GAMB-AIRE-CAR19', '18990-0000-19', 'Sin Información', 'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (20.0, 'INT-GAMB-AIRE-ANA20', '18010-0009-20', '199800014', 'ANALIZADOR DE HC', 'THERMO', '55C', '55C60839328', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA20', 2.0, 10.0, 4.0, 2.0, 1.0, 43.0, 86.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA20', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA20', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2026-12-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (21.0, 'INT-GAMB-AIRE-CAR21', '18990-0000-21', 'Sin Información', 'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (22.0, 'INT-GAMB-AIRE-CAR22', '18990-0000-22', 'Sin Información', 'Carcasa de VOC', 'ANDERSEN', '97-323-100', 'Sin Información', 'Aire (Calidad de Aire)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (23.0, 'INT-GAMB-AIRE-COM23', '18990-0000-23', '199711179', 'COMPRESOR', 'SIEMENS', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (24.0, 'INT-GAMB-AIRE-COM24', '18990-0000-24', '199711211', 'COMPUTADORA', 'HP', 'Sin Información', '651728', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (25.0, 'INT-GAMB-AIRE-COM25', '18990-0000-25', '7001359', 'computadora', 'HP', 'Compac', 'Sin Información', 'Aire (Calidad de Aire)', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (26.0, 'INT-GAMB-AIRE-CON26', '18990-0000-26', '200200623', 'CONSOLA METEOROLOGIA', 'YOUNG', 'Sin Información', 'PT05937', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON26', 3.0, 5.0, 2.0, 2.0, 8.0, 20.0, 60.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON26', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON26', NULL, NULL, 1.0, 'Mejora Continua Menor', NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, '2027-01-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (27.0, 'INT-GAMB-AIRE-CON27', '18990-0000-27', '119713208', 'CONVERTIDOR DE H2S', 'horiba', 'Sin Información', '575995022', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON27', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON27', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON27', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-02-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (28.0, 'INT-GAMB-AIRE-CON28', '18990-0000-28', '199713185', 'CONVERTIDOR DE NH3', 'HORIBA', 'BM-1A', '575995031', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON28', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON28', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-CON28', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-03-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (29.0, 'INT-GAMB-AIRE-CON29', '18990-0000-29', '199711149', 'CONVERTIDOR DE NH3', 'HORIBA', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (30.0, 'INT-GAMB-AIRE-DAT30', '18990-0000-30', '200100390', 'DATA LOGGER', 'Sin Información', 'Sin Información', '4256', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DAT30', 4.0, 10.0, 2.0, 1.0, 4.0, 25.0, 100.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DAT30', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DAT30', 5.25, 'Riesgo Medio', 9.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA', 'Reemplazo Planificado a Mediano Plazo', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-04-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (31.0, 'INT-GAMB-AIRE-DES31', '18010-0057-31', 'Sin Información', 'Deshumidificador de filtros 1', 'Sin Información', 'Sin Información', '5220', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (32.0, 'INT-GAMB-AIRE-DES32', '18010-0057-32', 'Sin Información', 'Deshumidificador de filtros 2', 'Sin Información', 'Sin Información', '5218', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES32', 2.0, 10.0, 2.0, 2.0, 1.0, 23.0, 46.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES32', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES32', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-05-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (33.0, 'INT-GAMB-AIRE-DES33', '18010-0057-33', '200600060', 'Deshumidificador de sala 1', 'WHITESONIC', 'WSPMID-12CR', '1.055308770601E+17', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES33', 2.0, 10.0, 2.0, 2.0, 1.0, 23.0, 46.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES33', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-DES33', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-06-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (34.0, 'INT-GAMB-AIRE-DES34', '18010-0057-34', '200600061', 'Deshumidificador de sala 2', 'WHITESONIC', 'WSPMID-12CR', '1.055308770601E+16', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (35.0, 'INT-GAMB-AIRE-ANA35', '18010-0009-35', '199712970', 'ANALIZADOR DE NH3', 'THERMO', '17C', '17C-61220330', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA35', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA35', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA35', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-07-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (36.0, 'INT-GAMB-AIRE-ANA36', '18010-0009-36', '199800015', 'ANALIZADOR DE NH3', 'THERMO', '55C', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (37.0, 'INT-GAMB-AIRE-ANA37', '18010-0009-37', '199713190', 'ANALIZADOR DE NO2', 'HORIBA', 'APNA-360', '574635092', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA37', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA37', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA37', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-08-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (38.0, 'INT-GAMB-AIRE-ANA38', '18010-0009-38', '199712975', 'ANALIZADOR DE NO2', 'THERMO', 'Sin Información', 'K199 1227230442 P', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (39.0, 'INT-GAMB-AIRE-ANA39', '18010-0009-39', '199800012', 'ANALIZADOR DE NO2', 'THERMO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (40.0, 'INT-GAMB-AIRE-ANA40', '18010-0009-40', '200601635', 'ANALIZADOR DE NOX', 'teledine', 'Sin Información', '1671', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (41.0, 'INT-GAMB-AIRE-ANA41', '18010-0009-41', '199712977', 'ANALIZADOR DE O3', 'THERMO', '49C', '49C-60817328', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (42.0, 'INT-GAMB-AIRE-ANA42', '18010-0009-42', '200603543', 'ANALIZADOR DE OZONO', 'THERMO', 'Sin Información', '936539417', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (43.0, 'INT-GAMB-AIRE-EQU43', '18990-0000-43', '199800643', 'EQUIPO PUFS', 'GRASEBY', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (44.0, 'INT-GAMB-AIRE-BOM44', '18010-0032-44', 'Sin Información', 'BOMBA SUCCION THOMAS', 'Sin Información', 'Sin Información', '0701-00000591', 'Aire (Calidad de Aire)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (45.0, 'INT-GAMB-AIRE-ANA45', '18010-0009-45', '200601647', 'ANALIZADOR  HIDROCARBUROS', 'Sin Información', 'Sin Información', '43268760062', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (46.0, 'INT-GAMB-AIRE-ANA46', '18010-0009-46', '199800011', 'ANALIZADOR DE OZONO', 'TERMO', 'Sin Información', '981118325', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (47.0, 'INT-GAMB-AIRE-ANA47', '18010-0009-47', '199713195', 'ANALIZADOR DE SO2', 'horiba', 'Sin Información', '575995011', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA47', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA47', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA47', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-09-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (48.0, 'INT-GAMB-AIRE-ANA48', '18010-0009-48', '199713195', 'ANALIZADOR DE SO2', 'HORIBA', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (49.0, 'INT-GAMB-AIRE-BOM49', '18010-0032-49', 'Sin Información', 'BOMBA DE SUCCIÓN  KNF', 'Sin Información', 'Sin Información', '406722', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-BOM49', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-BOM49', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-BOM49', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-10-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (50.0, 'INT-GAMB-AIRE-GAS50', '18990-0000-50', '199713739', 'Gas Chromatograph', 'Sin Información', '5890', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (51.0, 'INT-GAMB-AIRE-GEN51', '18990-0000-51', '199800149', 'GENERADOR DE H2', 'PACKARD', 'Sin Información', '191026841', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-GEN51', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-GEN51', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-GEN51', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, '2027-11-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (52.0, 'INT-GAMB-AIRE-GEN52', '18990-0000-52', '199800149', 'GENERADOR DE H2', 'PACKARD', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (53.0, 'INT-GAMB-AIRE-GEN53', '18990-0000-53', '199800149', 'GENERADOR DE HIDROGENO', 'Sin Información', 'Sin Información', '420439', 'Aire (Calidad de Aire)', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (54.0, 'INT-GAMB-AIRE-GIL54', '18990-0000-54', '199711186', 'GILIAN CALIBRADOR DE FLUJO', 'GILIAN', 'Sin Información', '390835609', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (55.0, 'INT-GAMB-AIRE-ANA55', '18010-0009-55', '199713188', 'ANALIZADOR DE HC', 'HORIBA', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (56.0, 'INT-GAMB-AIRE-INT56', '18990-0000-56', '199712737', 'Interfase', 'PE Nelson', 'PE Nelson', '7240252202', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (57.0, 'INT-GAMB-AIRE-INT57', '18990-0000-57', '199712736', 'Interfase', 'PE Nelson', 'PE Nelson', '7018272972', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (58.0, 'INT-GAMB-AIRE-MEZ58', '18010-0148-58', '199711189', 'MEZCLADOR DE GASES', 'ENVIRONIC', 'Sin Información', '7989-7081-6697', 'Aire (Calidad de Aire)', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MEZ58', 2.0, 10.0, 2.0, 1.0, 1.0, 22.0, 44.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MEZ58', 2.0, 2.0, 1.0, 3.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MEZ58', 7.75, 'Riesgo Alto', 2.0, 'Mejora Continua Menor', 'ALTO RIESGO OPERACIONAL', 'Preservación / RCM Mandatorio / Inspección', 'N/A', NULL, NULL, NULL, NULL, NULL, '2027-12-10');

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (59.0, 'INT-GAMB-AIRE-MEZ59', '18010-0148-59', '199713212', 'MEZCLADOR DE GASES', 'ENVIRONICS', 'Sin Información', '2-321312', 'Aire (Calidad de Aire)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (60.0, 'INT-GAMB-AIRE-DES60', '18010-0056-60', '199711915', 'DESECADOR DE FILTROS', 'NIKKO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (61.0, 'INT-GAMB-AIRE-MED61', '18010-0217-61', '199711906', 'MEDIDOR DE TEMP, HUM T PRESION', 'Sin Información', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (62.0, 'INT-GAMB-AIRE-MON62', '18990-0000-62', '199711261', 'MONITOR', 'HP', 'Sin Información', '900372', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (63.0, 'INT-GAMB-AIRE-ANA63', '18010-0009-63', '199711284', 'ANALIZADOR DE HC', 'HORIBA', 'APNA-360', '574635105', 'Aire (Calidad de Aire)', 'Sin Información', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (64.0, 'INT-GAMB-AIRE-BUR64', '18990-0000-64', '199711185', 'BURBUJOMETRO DE AIRE', 'Sin Información', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (65.0, 'INT-GAMB-AIRE-MUE65', '18990-0000-65', '199711215', 'Muestreador de COV', 'Graseby', '97-323-100', '997494', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (66.0, 'INT-GAMB-AIRE-MUE66', '18990-0000-66', '199711260', 'Muestreador de COV', 'Graseby', '97-323-100', '597467', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MUE66', 3.0, 5.0, 2.0, 1.0, 4.0, 15.0, 45.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MUE66', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-MUE66', 7.5, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', NULL, NULL, 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (67.0, 'INT-GAMB-AIRE-MUE67', '18990-0000-67', '199711270', 'Muestreador de COV', 'Graseby', '97-323-100', '1297504', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (68.0, 'INT-GAMB-AIRE-MUE68', '18990-0000-68', '199713269', 'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-D', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (69.0, 'INT-GAMB-AIRE-MUE69', '18990-0000-69', '199713217', 'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-B', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (70.0, 'INT-GAMB-AIRE-MUE70', '18990-0000-70', '199713252', 'Muestreador de partículas', 'ANDERSEN', '2000H', 'Sin Información', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (71.0, 'INT-GAMB-AIRE-MUE71', '18990-0000-71', '199713216', 'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', 'IC30-2', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (72.0, 'INT-GAMB-AIRE-MUE72', '18990-0000-72', '199713268', 'Muestreador de partículas', 'GENERAL METAL WORKS', '2000H', '4327-A', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (73.0, 'INT-GAMB-AIRE-BAL73', '18010-0025-73', '199712933', 'Balanza Analítica', 'METTLER TOLEDO', 'AB204', '29225', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (74.0, 'INT-GAMB-AIRE-TER74', '18010-0217-74', '20060', 'Termohigrómetro 2', 'EXTECH', 'SD700', 'Q673553', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (75.0, 'INT-GAMB-AIRE-TER75', '18010-0217-75', '20060', 'Termohigrómetro 3', 'EXTECH', 'SD700', 'Q673538', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (76.0, 'INT-GAMB-AIRE-MUE76', '18990-0000-76', '199711128', 'Muestreador de partículas', 'GRASEBY', '2000H', '4327-C', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (77.0, 'INT-GAMB-AIRE-MUE77', '18990-0000-77', '199711258', 'Muestreador de partículas', 'GRASEBY', '2000H', 'Sin Información', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (78.0, 'INT-GAMB-AIRE-BAL78', '18010-0025-78', '199711426', 'Balanza (Microbalanza)', 'METTLER TOLEDO', '650280', 'Sin Información', 'Aire (Calidad de Aire)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (79.0, 'INT-GAMB-AIRE-PRE79', '18990-0000-79', '200602254', 'Preconcentrador', 'Entech', '7100', 'Sin Información', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (80.0, 'INT-GAMB-AIRE-ANA80', '18010-0009-80', '199711197', 'Analizador de dióxido de azufre (SO2)', 'THERMO', '45C', 'Sin Información', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (81.0, 'INT-GAMB-AIRE-ANA81', '18010-0009-81', '200601653', 'Analizador de dioxidos de nitrogeno (NO2)', 'TELEDYNE', '201E', '071', 'Aire (Calidad de Aire)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (82.0, 'INT-GAMB-AIRE-ANA82', '18010-0009-82', '199712974', 'Analizador de Monoxido de Carbono', 'Thermo', '48C', '48c63285325', 'Aire (Calidad de Aire)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA82', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA82', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-AIRE-ANA82', 5.75, 'Riesgo Medio', 6.0, 'Oportunidad Prioritaria', 'OBSOLESCENCIA ALTA', 'Reemplazo Planificado a Mediano Plazo', 'Implementar y Adquirir en el Plan Operativo Corto Plazo', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (83.0, 'INT-GAMB-AIRE-QUI83', '18990-0000-83', '199711125', 'QUINTOX', 'KANE-MAY', 'Sin Información', '0490-1176', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (84.0, 'INT-GAMB-AIRE-RAD84', '18990-0000-84', '199711924', 'RADAR ACUSTICO', 'REMTECH', 'Sin Información', 'WVT09ABTWW', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (85.0, 'INT-GAMB-AIRE-SIN85', '18990-0000-85', '199711142', 'SINGLE PROBE CONTROLLER', 'TERMO', 'Sin Información', 'Sin Información', 'Aire (Calidad de Aire)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (86.0, 'INT-GAMB-AIRE-TES86', '18010-0156-86', '199712940', 'TESTER', 'MICRONTA', 'Sin Información', '900241', 'Aire (Calidad de Aire)', 'Media', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (87.0, 'INT-GAMB-BIOT-AGI87', '18010-0001-87', '199709024', 'AGITADOR VORTEX', 'GENIE 2', 'Sin información', '2-321312', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AGI87', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AGI87', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AGI87', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (88.0, 'INT-GAMB-BIOT-AGI88', '18010-0001-88', '199712070', 'AGITADOR VORTEX', 'MAXMIX', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (89.0, 'INT-GAMB-BIOT-AGI89', '18010-0001-89', '199712046', 'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (90.0, 'INT-GAMB-BIOT-AUT90', '18010-0024-90', '199710937', 'AUTO CLAVE', 'Sin información', 'Sin información', '159454', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AUT90', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AUT90', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-AUT90', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (91.0, 'INT-GAMB-BIOT-AUT91', '18010-0024-91', '200200749', 'AUTO CLAVE', 'Sin información', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (92.0, 'INT-GAMB-BIOT-BAC92', '18990-0000-92', '199709021', 'BACTI INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (93.0, 'INT-GAMB-BIOT-BAL93', '18010-0025-93', '200601465', 'BALANZA ELECTRONICA', 'ADVENTURER', 'Sin información', 'K199 1227230442 P', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (94.0, 'INT-GAMB-BIOT-BOM94', '18010-0032-94', '199711938', 'BOMBA PERISTATICA', 'MEB CORP', 'Sin información', 'M9000403', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (95.0, 'INT-GAMB-BIOT-CAM95', '18010-0037-95', '199710906', 'CAMARA ANAEROBICA', 'MECAPLEX', 'Sin información', '91218', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (96.0, 'INT-GAMB-BIOT-CAM96', '18010-0037-96', '199712226', 'CAMARA DE ELECTROFORESIS', 'Thermo Scientific', 'Sin información', 'H5-9255', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM96', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM96', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM96', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (97.0, 'INT-GAMB-BIOT-CAM97', '18010-0037-97', '199712227', 'CAMARA DE ELECTROFORESIS', 'Thermo Scientific', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (98.0, 'INT-GAMB-BIOT-CAM98', '18010-0095-98', '199712210', 'CAMPANA # 1  DE EXTRACCION CON 2 COMPARTIMIENTOS', 'Sin información', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (99.0, 'INT-GAMB-BIOT-CAM99', '18010-0095-99', '199712248', 'CAMPANA # 2 DE EXTRACCION CON 2 COMPARTIMIENTOS', 'Sin información', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (100.0, 'INT-GAMB-BIOT-CAM100', '18010-0095-100', '199710927', 'CAMPANA DE BIOSEGURIDAD', 'KOTTERMAN', 'Sin información', 'Sin Información', 'Biotecnología', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (101.0, 'INT-GAMB-BIOT-CAM101', '18010-0095-101', '199710926', 'CAMPANA DE BIOSEGURIDAD', 'KOTTERMAN', 'Sin información', 'Sin Información', 'Biotecnología', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (102.0, 'INT-GAMB-BIOT-CAM102', '18010-0095-102', '199710929', 'CAMPANA DE BIOSEGURIDAD', 'LABCONCO', 'Sin información', '214803', 'Biotecnología', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM102', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM102', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CAM102', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (103.0, 'INT-GAMB-BIOT-CEN103', '18010-0042-103', '200603560', 'CENTRIFUGA', 'EPPENDORF.', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (104.0, 'INT-GAMB-BIOT-CON104', '18990-0000-104', '20130245', 'CONGELADOR VERTICAL', 'WHIRPOOL', 'Sin información', 'WVT09ABTWW', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (105.0, 'INT-GAMB-BIOT-DES105', '18010-0058-105', '199710935', 'DESTILADOR', 'MEGAPURE', 'Sin información', '7989-7081-6697', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (106.0, 'INT-GAMB-BIOT-DIS106', '18010-0065-106', '199710947', 'DISPENSADOR AUTOMATICO', 'MASTERFLEX', 'Sin información', '651728', 'Biotecnología', 'Baja', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (107.0, 'INT-GAMB-BIOT-EST107', '18010-0092-107', '199710925', 'ESTUFA', 'MEMMERT', 'Sin información', '900372', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (108.0, 'INT-GAMB-BIOT-EST108', '18010-0092-108', '199710936', 'ESTUFA', 'MEMMERT', 'Sin información', '900241', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-EST108', 2.0, 10.0, 2.0, 3.0, 1.0, 24.0, 48.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-EST108', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-EST108', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (109.0, 'INT-GAMB-BIOT-FER109', '18010-0063-109', '199710933', 'FERMENTADOR', 'BIOSTAT', 'Sin información', '665', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (110.0, 'INT-GAMB-BIOT-FRE110', '18010-0159-110', '199710930', 'FREEZER  - 86°C', 'FORMA SCIENTIFIC', 'Sin información', '85332-241', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (111.0, 'INT-GAMB-BIOT-INC111', '18010-0092-111', '199710939', 'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (112.0, 'INT-GAMB-BIOT-INC112', '18010-0092-112', '199712151', 'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (113.0, 'INT-GAMB-BIOT-INC113', '18010-0092-113', '199712152', 'INCINERADOR', 'OXFORD', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (114.0, 'INT-GAMB-BIOT-INC114', '18010-0123-114', '199710905', 'INCUBADOR (AGIT. Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '390835609', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (115.0, 'INT-GAMB-BIOT-INC115', '18010-0123-115', '199710943', 'INCUBADOR (AGIT. Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '981118325', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (116.0, 'INT-GAMB-BIOT-INC116', '18010-0123-116', '199710944', 'INCUBADOR AGIT .Y TEMP.)', 'NEW BRUNSWICK', 'Sin información', '191026841', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-INC116', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-INC116', 1.0, 2.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-INC116', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (117.0, 'INT-GAMB-BIOT-INC117', '18010-0123-117', '199710945', 'INCUBADOR CON AGITACION Y TEMPERATURA', 'LABLINE', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (118.0, 'INT-GAMB-BIOT-INC118', '18010-0123-118', '199710924', 'INCUBADOR ESTATICO', 'LABLINE', 'Sin información', '0490-1176', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (119.0, 'INT-GAMB-BIOT-MEC119', '18010-0143-119', '199711937', 'MECHERO DE CAMPANA', 'FIREBOY', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (120.0, 'INT-GAMB-BIOT-MIC120', '18010-0150-120', '199710918', 'MICROSCOPIO', 'NIKON', 'Sin información', '320939', 'Biotecnología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MIC120', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MIC120', 1.0, 2.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MIC120', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (121.0, 'INT-GAMB-BIOT-MIC121', '18010-0150-121', '199710919', 'MICROSCOPIO', 'ZEIZZ', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (122.0, 'INT-GAMB-BIOT-CEN122', '18010-0042-122', '-', 'CENTRÍFUGA  MINI CENTRÍFUGA', 'FISHER SCIENTIFIC', 'Sin información', '100913221', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (123.0, 'INT-GAMB-BIOT-PLA123', '18010-0001-123', '199712241', 'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', '6389-3080-0814', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (124.0, 'INT-GAMB-BIOT-PLA124', '18010-0001-124', '199712236', 'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (125.0, 'INT-GAMB-BIOT-PLA125', '18010-0001-125', '199712239', 'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (126.0, 'INT-GAMB-BIOT-PLA126', '18010-0001-126', '199710966', 'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (127.0, 'INT-GAMB-BIOT-PLA127', '18010-0001-127', '199712235', 'PLANCHA DE AGITACION', 'THERMOLYNE', 'Sin información', 'Sin Información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (128.0, 'INT-GAMB-BIOT-PLA128', '18010-0001-128', '199712036', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'THERMOLYNE', 'Sin información', '612911-018010', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (129.0, 'INT-GAMB-BIOT-PLA129', '18010-0001-129', '199712215', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO', 'CORNING', 'Sin información', 'Sin información', 'Biotecnología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (130.0, 'INT-GAMB-BIOT-REF130', '18010-0159-130', '-', 'REFRIGERADOR', 'Sin información', 'Sin información', 'Cod. Inventario 592-0105', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (131.0, 'INT-GAMB-BIOT-REF131', '18010-0159-131', '200601032', 'REFRIGERADOR', 'LAB LINE', 'Sin información', 'Sin Información', 'Biotecnología', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (132.0, 'INT-GAMB-BIOT-ROT132', '18010-0058-132', '200200093', 'ROTAVAPOR', 'BUCHI', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (133.0, 'INT-GAMB-BIOT-AGI133', '18010-0001-133', '199712240', 'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', '2-278554', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (134.0, 'INT-GAMB-BIOT-AGI134', '18010-0001-134', '199710938', 'AGITADOR VORTEX', 'THERMOLYNE', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (135.0, 'INT-GAMB-BIOT-AGI135', '18010-0001-135', 'Sin Información', 'AGITADOR VORTEX', 'VM-2000', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (136.0, 'INT-GAMB-BIOT-DIS136', '18010-0065-136', 'Sin Información', 'dispensador automatico', 'IBX Instruments', 'P 10 +', '2025113079', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (137.0, 'INT-GAMB-BIOT-CEN137', '18010-0042-137', 'Sin Información', 'CENTRÍFUGA microcentrifuga', 'dinamic', 'velocity 15 pro', '709600L', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (138.0, 'INT-GAMB-BIOT-BIO138', '18990-0000-138', '199709199', 'BIOSCREEN MBR', 'Bioscreen', 'Sin información', '110001-438', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BIO138', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BIO138', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BIO138', 7.5, 'Riesgo Alto', NULL, NULL, 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (139.0, 'INT-GAMB-BIOT-CUE139', '18990-0000-139', '199710941', 'CUENTA COLONIAS', 'DARKFIELD', 'Sin información', 'Sin Información', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CUE139', 1.0, 1.0, 1.0, 2.0, 1.0, 4.0, 4.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CUE139', 1.0, 1.0, 2.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-CUE139', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (140.0, 'INT-GAMB-BIOT-BAL140', '18010-0025-140', 'Sin Información', 'BALANZA ELETRONICA', 'Metler toledo', 'Sin información', '1125473951', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BAL140', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BAL140', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-BAL140', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (141.0, 'INT-GAMB-BIOT-HOM141', '18010-0148-141', '200604903', 'HOMOGEINIZADOR', 'THERMO SCIENTIFIC', 'Sin información', 'Sin Información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (142.0, 'INT-GAMB-BIOT-LAM142', '18990-0000-142', '199712234', 'LAMPARA DE UV PARA LA CAMARA DE ELECTROPHERESIS', 'PHOTODOC-IT', 'Sin información', 'SLA1-1092-1064', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (143.0, 'INT-GAMB-BIOT-MIC143', '18990-0000-143', 'Sin Información', 'MICROONDAS', 'LG', 'Sin información', '811TAXT06114', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (144.0, 'INT-GAMB-BIOT-MUL144', '18990-0000-144', 'Sin Información', 'multiparametro', 'APERA', '1220361005', 'PC 910', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL144', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL144', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL144', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (145.0, 'INT-GAMB-BIOT-MUL145', '18010-0156-145', '200604478', 'MULTISKAN', 'ASCENT', 'Sin información', 'Sin Información', 'Biotecnología', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (146.0, 'INT-GAMB-BIOT-MUL146', '18010-0156-146', '20060042', 'MULTISKAN', 'ACCENT', 'Sin información', 'Sin Información', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL146', 1.0, 10.0, 1.0, 3.0, 4.0, 17.0, 17.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL146', 2.0, 2.0, 2.0, 2.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-MUL146', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (147.0, 'INT-GAMB-BIOT-SIS147', '18990-0000-147', '200604352', 'SISTEMA DE DOCUMENTACION DE GELES.', 'Sin información', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (148.0, 'INT-GAMB-BIOT-TER148', '18990-0000-148', '200603187', 'TERMOCICLADOR', 'ESCO', 'Sin información', 'Sin información', 'Biotecnología', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (149.0, 'INT-GAMB-BIOT-TER149', '18010-0217-149', '200604390', 'TERMOHIGROMETRO BAROMETRO.', 'Extech', 'Sin información', 'S:Q673623', 'Biotecnología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-BIOT-TER149', 1.0, 1.0, 2.0, 2.0, 1.0, 5.0, 5.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-BIOT-TER149', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-BIOT-TER149', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (150.0, 'INT-GAMB-DESE-DES150', '18010-0058-150', '199800510', 'destilador', 'Barnstead', 'MP- 6a', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (151.0, 'INT-GAMB-DESE-AGI151', '18010-0001-151', '1997-10871', 'Agitador Magnético', 'LABLINE Instruments', '1278', '0993-2607', 'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (152.0, 'INT-GAMB-DESE-AGI152', '18010-0001-152', '2006-04543', 'Agitador orbital', 'Heidolph', 'UNIMAX1010DT', '100503933', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-AGI152', 1.0, 5.0, 4.0, 2.0, 4.0, 26.0, 26.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-AGI152', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-AGI152', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (153.0, 'INT-GAMB-DESE-AGI153', '18010-0001-153', '1997-11093', 'Agitador orbital', 'Thermolyne', 'AROS 160', '660911126619', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (154.0, 'INT-GAMB-DESE-AGI154', '18010-0001-154', '1997-11092', 'Agitador orbital', 'Thermolyne', 'AROS 160', '666911126616', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (155.0, 'INT-GAMB-DESE-BOM155', '18010-0032-155', '1997-10873', 'Bomba de vacío', 'LEYBOLD', 'D8A', '92500067', 'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (156.0, 'INT-GAMB-DESE-CEN156', '18010-0042-156', '1997-711050', 'Centrífuga', 'DAMON/IEC', 'HN-SII', '23556644', 'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (157.0, 'INT-GAMB-DESE-EST157', '18010-0092-157', '199710850', 'Estufa', 'Stabil Therm', 'D-5226-Q', 'OU-11189', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (158.0, 'INT-GAMB-DESE-EST158', '18010-0092-158', '199710877', 'Estufa', 'Fisher', '550', '0401393', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (159.0, 'INT-GAMB-DESE-EST159', '18010-0092-159', '199710852', 'Estufa', 'VWR', '1600 HAFO Series', 'MD 9607', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (160.0, 'INT-GAMB-DESE-PHM160', '18010-0145-160', '20130430', 'pHmetro', 'Metrohm', '827', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (161.0, 'INT-GAMB-DESE-PLA161', '18010-0001-161', '199712037', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'Thermolyne', 'Cimarec 3', '612911018008', 'Desechos ( Tratabilidad de Desechos)', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (162.0, 'INT-GAMB-DESE-REF162', '18990-0000-162', '200601770', 'Refrigerador', 'Fisher Scientific', '13-986-450R', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (163.0, 'INT-GAMB-DESE-ROT163', '18010-0058-163', '200200408', 'Rotavapor', 'Yamato', 'BM400', 'BO300035', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-ROT163', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-ROT163', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-ROT163', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (164.0, 'INT-GAMB-DESE-ROT164', '18010-0058-164', '200100222', 'Rotavapor', 'BUCHI', 'B490/R200', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (165.0, 'INT-GAMB-DESE-ROT165', '18010-0058-165', '199800003', 'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (166.0, 'INT-GAMB-DESE-ROT166', '18010-0058-166', '199800136', 'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (167.0, 'INT-GAMB-DESE-ROT167', '18010-0058-167', '199711053', 'Rotax', 'VELP Scientifica', 'ROTAX 6.8', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (168.0, 'INT-GAMB-DESE-REF168', '18010-0159-168', 'Sin Información', 'Refrigerador', 'LIEBHERR', 'SCIENTIFIC', '903335200', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-REF168', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-REF168', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-REF168', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (169.0, 'INT-GAMB-DESE-EQU169', '18010-0021-169', 'Sin Información', 'Equipo Tamizador', 'FRITSCH', 'SPARTAN', '03.8020/06308', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-EQU169', 2.0, 10.0, 1.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-EQU169', 2.0, 1.0, 1.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-EQU169', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (170.0, 'INT-GAMB-DESE-BAL170', '18010-0025-170', '2006-01427', 'Balanza Analítica', 'Metler toledo', 'AB204-SN', '1127113130', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (171.0, 'INT-GAMB-DESE-BAL171', '18010-0025-171', '199710858', 'Balanza Analítica', 'Mettler', 'AT 201', 'P05562', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (172.0, 'INT-GAMB-DESE-CON172', '18990-0000-172', '200604385', 'Conductímetro', 'HACH', 'SenION+', '213097', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-CON172', 2.0, 10.0, 1.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-CON172', 1.0, 1.0, 1.0, 3.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-CON172', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (173.0, 'INT-GAMB-DESE-EXT173', '18010-0095-173', 'Sin Información', 'Extractor de aceites y grasas', 'VELP Scientifica', 'SER148', '53123', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-EXT173', 4.0, 5.0, 1.0, 2.0, 1.0, 8.0, 32.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-EXT173', 3.0, 3.0, 3.0, 3.0, 12.0, 100.0, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-EXT173', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (174.0, 'INT-GAMB-DESE-MIC174', '18990-0000-174', '200602349', 'Microondas', 'CEM', 'MarsXpress', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (175.0, 'INT-GAMB-DESE-MUL175', '18990-0000-175', 'Sin Información', 'multiparametro', 'APERA INSTRUMENTS', 'PC 910', '1220361007', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-MUL175', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-MUL175', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-MUL175', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (176.0, 'INT-GAMB-DESE-MUF176', '18010-0158-176', 'Sin Información', 'Mufla', 'Fisher Scientific', '550-126', '1511070561427', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (177.0, 'INT-GAMB-DESE-PUL177', '18990-0000-177', 'Sin Información', 'pulverizador', 'Herzog', 'HSM-250H', 'MA 19366-1', 'Desechos ( Tratabilidad de Desechos)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (178.0, 'INT-GAMB-DESE-REC178', '18010-0027-178', '199800542', 'Recirculador', 'NESLAB', 'RTE-111', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-REC178', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-REC178', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-REC178', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (179.0, 'INT-GAMB-DESE-REC179', '18010-0081-179', '199710820', 'Recirculador', 'NESLAB', 'RTE-111', 'Sin Información', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (180.0, 'INT-GAMB-DESE-TER180', '18010-0217-180', '200604887', 'Termohigrómetro', 'EXTECH', 'SD700', 'Q673624', 'Desechos ( Tratabilidad de Desechos)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-DESE-TER180', 3.0, 5.0, 4.0, 1.0, 1.0, 22.0, 66.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-DESE-TER180', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-DESE-TER180', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (181.0, 'INT-GAMB-ECOT-MED181', '18010-0145-181', '200200026', 'MEDIDOR DE MULTIPARÁMETROS', 'HACH', 'SENSION 378', '40400002652', 'Ecotoxicología', 'Media', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED181', 2.0, 1.0, 1.0, 1.0, 1.0, 3.0, 6.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED181', 3.0, 3.0, 2.0, 3.0, 11.0, 91.67, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED181', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (182.0, 'INT-GAMB-ECOT-BAL182', '18010-0025-182', '199710999', 'BALANZA ANALÍTICA', 'METTLER', 'AJ180', '930', 'Ecotoxicología', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (183.0, 'INT-GAMB-ECOT-BAL183', '18010-0025-183', '200100102', 'BALANZA ANALÍTICA', 'METTLER TOLEDO', 'PB3002-S', '1120201863', 'Ecotoxicología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL183', 1.0, 5.0, 4.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL183', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL183', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (184.0, 'INT-GAMB-ECOT-BAL184', '18010-0025-184', '200600397', 'BALANZA ANALÍTICA', 'AND', 'GR200', '14220316', 'Ecotoxicología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL184', 1.0, 10.0, 2.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL184', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-BAL184', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (185.0, 'INT-GAMB-ECOT-MED185', '18990-0000-185', '200200426', 'MEDIDOR DE OXÍGENO DISUELTO PORTÁTIL', 'YELLOW SPRING INSTRUMENT CO. YSI', 'Sin información', '02D1306', 'Ecotoxicología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED185', 1.0, 5.0, 1.0, 1.0, 1.0, 7.0, 7.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED185', 3.0, 3.0, 2.0, 3.0, 11.0, 91.67, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MED185', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (186.0, 'INT-GAMB-ECOT-MIC186', '18990-0000-186', '199800472', 'MICROTOX', 'AZUR ENVIRONMENTAL', 'OMNI/M500', '5001577', 'Ecotoxicología', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC186', 3.0, 10.0, 4.0, 3.0, 1.0, 44.0, 132.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC186', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC186', 8.25, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (187.0, 'INT-GAMB-ECOT-REF187', '18010-0196-187', '199709004', 'REFRACTÓMETRO PORTÁTIL', 'ATAGO', 'S/MILL 8904', 'Sin Información', 'Ecotoxicología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (188.0, 'INT-GAMB-ECOT-REF188', '18010-0196-188', 'Sin Información', 'REFRACTÓMETRO PORTÁTIL', 'PORTABLE REFRAKTOMETER', '13-946-27', 'Sin Información', 'Ecotoxicología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (189.0, 'INT-GAMB-ECOT-PLA189', '18010-0001-189', '1997708992', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO GRANDE', 'THERMOLYNE', 'SP47235-60', '612911018002', 'Ecotoxicología', '0', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (190.0, 'INT-GAMB-ECOT-PLA190', '18010-0001-190', '199710964', 'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130849', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA190', 1.0, 5.0, 1.0, 1.0, 4.0, 10.0, 10.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA190', 2.0, 2.0, 2.0, 3.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA190', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (191.0, 'INT-GAMB-ECOT-PLA191', '18010-0001-191', '199710966', 'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130858', 'Ecotoxicología', '0', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (192.0, 'INT-GAMB-ECOT-PLA192', '18010-0001-192', '199710965', 'PLANCHA DE AGITACIÓN PEQUEÑA', 'THERMOLYNE', 'S46725', '638911130859', 'Ecotoxicología', '0', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (193.0, 'INT-GAMB-ECOT-EST193', '18010-0092-193', '199710995', 'ESTUFA', 'BLUE M ELECTRIC COMPANY', 'Sin información', 'Sin información', 'Ecotoxicología', '0', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (194.0, 'INT-GAMB-ECOT-MEZ194', '18010-0148-194', '200100115', 'MEZCLADORA', 'IKA LABORTECHNIK', 'RW20 N 51', '3106887', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (195.0, 'INT-GAMB-ECOT-SIS195', '18010-0097-195', '199800420', 'SISTEMA DE FILTRACIÓN DE CARBÓN ACTIVADO', 'AQUATIC', '416014B', 'Sin Información', 'Ecotoxicología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (196.0, 'INT-GAMB-ECOT-NEV196', '18010-0159-196', '200200602', 'NEVERA', 'WHIRLPOOL', 'ETILFKXKT02', 'EM3823349', 'Ecotoxicología', '0', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (197.0, 'INT-GAMB-ECOT-MIC197', '18010-0150-197', '199711115', 'MICROSCOPIO ÓPTICO AXIOPLANT DE LUZ TRANSMITIDA', 'ZEISS', '7082', '451485', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (198.0, 'INT-GAMB-ECOT-MIC198', '18010-0150-198', '199711114', 'MICROSCOPIO ESTEREOSCÓPICO', 'ZEISS', 'STEMI SVII', '415826', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC198', 2.0, 5.0, 1.0, 2.0, 1.0, 8.0, 16.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC198', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC198', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (199.0, 'INT-GAMB-ECOT-MIC199', '18010-0150-199', '200600415', 'MICROSCOPIO INVERTIDO', 'LEICA', 'DMIL', '90135002', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC199', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC199', 3.0, 2.0, 2.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-MIC199', 6.75, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (200.0, 'INT-GAMB-ECOT-ADJ200', '18010-0001-200', '199711092', 'ADJUSTABLE RECIPROCATING ORBITAL SHAKER', 'BARNSTEAD/THERMOLYNE', 'M66025', '660911126616', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (201.0, 'INT-GAMB-ECOT-CÁM201', '18990-0000-201', '200600416', 'CÁMARA FOTOGRÁFICA DIGITAL PARA MICROSCOPIO', 'LEICA', 'DFC490', '148702206B', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (202.0, 'INT-GAMB-ECOT-LÁM202', '18990-0000-202', 'Sin Información', 'LÁMPARA DE MERCURIO', 'LEISTUNGSELERKTRONIC JENA GmbH', 'mbq52ac-L IP20', '70370105235', 'Ecotoxicología', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (203.0, 'INT-GAMB-ECOT-EST203', '18010-0092-203', 'Sin Información', 'ESTUFA', 'FISHER SCIENTIFIC', '725-F', '1584070236548', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (204.0, 'INT-GAMB-ECOT-PLA204', '18010-0001-204', '199712239', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (205.0, 'INT-GAMB-ECOT-PLA205', '18010-0001-205', '199712105', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA205', 1.0, 5.0, 1.0, 1.0, 4.0, 10.0, 10.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA205', 2.0, 2.0, 2.0, 3.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-ECOT-PLA205', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (206.0, 'INT-GAMB-ECOT-PLA206', '18010-0001-206', '199712235', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'CORNING', 'PC-420', '430506125253', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (207.0, 'INT-GAMB-ECOT-CAM207', '18010-0095-207', '199709018', 'CAMPANA DE EXTRACCIÓN', 'Sin información', 'Sin información', 'Sin información', 'Ecotoxicología', 'Alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (208.0, 'INT-GAMB-ECOT-DES208', '18010-0058-208', '199710991', 'DESTILADOR', 'CORNING MEGA-PURE', '12 LITER AUTO MP12A', '146', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (209.0, 'INT-GAMB-ECOT-MIC209', '18010-0150-209', '199712278', 'MICROSCOPIO ÓPTICO', 'LEICA', 'NO.31-75-05', '1588-LT', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (210.0, 'INT-GAMB-ECOT-PLA210', '18010-0001-210', '199710961', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO GRANDE', 'THERMOLYNE', 'SP42735-60', '612910909179', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (211.0, 'INT-GAMB-ECOT-BOM211', '18010-0032-211', '199708995', 'BOMBA DE AGUA', 'JACUZZI BROS', '940226770', '4781012', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (212.0, 'INT-GAMB-ECOT-TER212', '18010-0217-212', 'Sin Información', 'TERMOHIGRÓMETRO', 'TRACEABLE® BIG DIG', '6066N53', '61998285', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (213.0, 'INT-GAMB-ECOT-CÁM213', '18990-0000-213', '200601512', 'CÁMARA DE CRECIMIENTO', 'CONVIRON', 'BDR 16', '70175', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (214.0, 'INT-GAMB-ECOT-CAM214', '18010-0095-214', '200602640', 'CAMPANA DE FLUJO HORIZONTAL', 'LABCONCO', 'PURIFIER', '704694877', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (215.0, 'INT-GAMB-ECOT-MIC215', '18010-0150-215', '0', 'MICROSCOPIO ESTEREOSCÓPICO', 'NACIONAL OPTICAL & SCIENTIFIC INSTRUMENTS INC.', 'DC5-420TH', '12001315', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (216.0, 'INT-GAMB-ECOT-MIC216', '18990-0000-216', '200604479', 'MICROTOX', 'MODERN WATER', 'M-500', '5002915', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (217.0, 'INT-GAMB-ECOT-NEV217', '18010-0159-217', '200600778', 'NEVERA', 'BARNSTEAD INTERNATIONAL', '3751', '1422070563362', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (218.0, 'INT-GAMB-ECOT-MUF218', '18010-0158-218', '199711039', 'MUFLA', 'NEY', 'M-525 SII', 'AKN9339-157', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (219.0, 'INT-GAMB-ECOT-DES219', '18010-0058-219', '0', 'DESTILADOR DE AGUA', 'GFL', '2004', '11669312J', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (220.0, 'INT-GAMB-ECOT-DES220', '18010-0058-220', '0', 'DESIONIZADOR DE AGUA', 'THERMO - BARNSTEAD', 'MEGA-PURE D1', '494240-39', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (221.0, 'INT-GAMB-ECOT-LAM221', '18990-0000-221', '199709740', 'LAMPARA', 'ZEISS', 'KL 1500', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (222.0, 'INT-GAMB-ECOT-PLA222', '18010-0001-222', '199712236', 'PLANCHA DE AGITACIÓN Y CALENTAMIENTO PEQUEÑA', 'MAGNE-4', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (223.0, 'INT-GAMB-ECOT-MON223', '18990-0000-223', '2001689', 'MONITOR', 'Sin Información', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (224.0, 'INT-GAMB-ECOT-CPU224', '18990-0000-224', '2000903', 'CPU', 'VIT', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (225.0, 'INT-GAMB-ECOT-MON225', '18990-0000-225', '2048427', 'MONITOR', 'SIRAGON', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (226.0, 'INT-GAMB-ECOT-CPU226', '18990-0000-226', '2048476', 'CPU', 'SIRAGON', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (227.0, 'INT-GAMB-ECOT-LEC227', '18990-0000-227', '2018787', 'LECTOR DE CODIGO', 'Sin Información', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (228.0, 'INT-GAMB-ECOT-REF228', '18010-0159-228', '200600778', 'REFRIGERADOR', 'BARNSTEAD', 'Sin Información', 'Sin Información', 'Ecotoxicología', '0', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (229.0, 'INT-GAMB-EFLU-BAÑ229', '18010-0081-229', '199711052', 'BAñO Recirculante', 'HAAKE', '001-0506', '9107797', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (230.0, 'INT-GAMB-EFLU-DES230', '18010-0058-230', '200200092', 'Destilador de agua', 'BARNSTEAD', 'A440696', '675980714108', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES230', 2.0, 10.0, 2.0, 2.0, 4.0, 26.0, 52.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES230', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES230', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (231.0, 'INT-GAMB-EFLU-ROT231', '18010-0058-231', '199800128', 'Rotaevaporador', 'YAMATO', 'RE500', '45700044', 'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (232.0, 'INT-GAMB-EFLU-MED232', '18010-0145-232', '200601015', 'Medidor de pH', 'Thermo Orion', 'Orion 330', '17728', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (233.0, 'INT-GAMB-EFLU-MED233', '18010-0145-233', '200601014', 'Medidor de conductividad', 'WTW', '197i', '517325', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (234.0, 'INT-GAMB-EFLU-BAT234', '18010-0095-234', '200600963', 'Batería de Mantas Calefactoras para Digestión Kjeldahl y Extracción', 'Selecta', '6003294', '502696', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAT234', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAT234', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAT234', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (235.0, 'INT-GAMB-EFLU-DES235', '18990-0000-235', '200200388', 'Desionizador de agua', 'Barnstead', 'Megapure D2', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES235', 3.0, 10.0, 4.0, 2.0, 1.0, 43.0, 129.0, 'Nivel A (Alto - Crítico)', 'Selección Obligatoria (Pasa a Evaluación)', 'Requiere evaluación sistemática de riesgos y oportunidades en las 4 etapas del ciclo de vida');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES235', 3.0, 3.0, 1.0, 3.0, 10.0, 83.33, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES235', NULL, NULL, NULL, NULL, NULL, NULL, 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (236.0, 'INT-GAMB-EFLU-ANA236', '18010-0009-236', '-', 'Analizador de Carbono Orgánico Total y Nitrógeno Total', 'Tekmar', 'Apollo 9000TM', 'US04190003', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (237.0, 'INT-GAMB-EFLU-BAL237', '18010-0025-237', '199800316', 'Balanza de Precisión', 'Mettler', 'PB5001', '1117301085', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (238.0, 'INT-GAMB-EFLU-CEN238', '18010-0042-238', '200601493', 'Centrífuga', 'Labnet', 'Z200A', '44060372', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (239.0, 'INT-GAMB-EFLU-MED239', '18010-0146-239', '200601487', 'Medidor de flujo', 'Global Water', 'FP-201', '45709', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (240.0, 'INT-GAMB-EFLU-PLA240', '18010-0001-240', '199711037', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'NUOVA II', 'S18525', '30709271', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (241.0, 'INT-GAMB-EFLU-RAD241', '18990-0000-241', '200200736', 'Radiómetro', 'VLX', '254', '05-13785', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (242.0, 'INT-GAMB-EFLU-DES242', '18010-0056-242', '200200404', 'Desecador', 'SANPLATEC CORP.', 'Dry Keeper', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (243.0, 'INT-GAMB-EFLU-CÁM243', '18990-0000-243', '199800296', 'Cámara digital', 'Sony', 'MVC-FD73', '177941', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (244.0, 'INT-GAMB-EFLU-BOM244', '18010-0032-244', '199711000', 'Bomba peristáltica', 'Cole Parmer', '7523-10', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (245.0, 'INT-GAMB-EFLU-PLA245', '18010-0001-245', '199710961', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'Sin Información', 'SP47235-60', '612910909177', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (246.0, 'INT-GAMB-EFLU-PLA246', '18010-0001-246', '199710826', 'Plancha de agitación', 'Corning', 'Sin Información', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (247.0, 'INT-GAMB-EFLU-PLA247', '18010-0001-247', '199711003', 'Plancha de agitación', 'Cole Parmer', 'Sin Información', '233687', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (248.0, 'INT-GAMB-EFLU-BAÑ248', '18010-0027-248', '200200387', 'Baño de agua', 'PRECISION', 'Sin información', '602051240', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (249.0, 'INT-GAMB-EFLU-MED249', '18010-0146-249', '200200338', 'Medidor multiparámetro', 'HACH', 'SENSION 156', '20100001842', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (250.0, 'INT-GAMB-EFLU-MED250', '18010-0146-250', '199711043', 'Medidor de ozono', 'OREC', 'DM-100', 'DM100-695', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (251.0, 'INT-GAMB-EFLU-MED251', '18010-0146-251', '200601774', 'Medidor de Oxígeno Disuelto', 'YSY', '52CE', '04 M1081', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (252.0, 'INT-GAMB-EFLU-PLA252', '18010-0001-252', '199711003', 'Plancha pequeña de agitación', 'Cole Parmer', 'Micro V', '233687', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (253.0, 'INT-GAMB-EFLU-BOM253', '18010-0032-253', '200100033', 'Bomba peristáltica', 'Geopump', '900-1280', '604004652', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (254.0, 'INT-GAMB-EFLU-BOM254', '18010-0032-254', 'Sin Información', 'Bomba de vacío', 'General electric', 'SKH3EKN90HX', '898', 'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BOM254', 1.0, 5.0, 2.0, 2.0, 1.0, 13.0, 13.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BOM254', 2.0, 2.0, 2.0, 2.0, 8.0, 66.67, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BOM254', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (255.0, 'INT-GAMB-EFLU-EST255', '18010-0092-255', '200600961', 'Estufa', 'Selecta', 'Digitheat', '502690', 'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-EST255', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-EST255', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-EST255', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (256.0, 'INT-GAMB-EFLU-MED256', '18010-0146-256', '-', 'Medidor de distribución de tamaño de partículas', 'MALVERN', 'MAF5000', 'MAL400167', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (257.0, 'INT-GAMB-EFLU-MED257', '18010-0146-257', '200600388', 'Medidor de flujo', 'Dynasonics Ultrasonic Flowmeter', 'D904-A 1NA-NN', '37237', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (258.0, 'INT-GAMB-EFLU-MED258', '18010-0146-258', '-', 'Medidor de oxígeno disuelto', 'YSY', '5000-115V', '06K1526', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (259.0, 'INT-GAMB-EFLU-TUR259', '18990-0000-259', '200602824', 'Turbidímetro', 'HACH', '2100', '10030C026149', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (260.0, 'INT-GAMB-EFLU-BOM260', '18010-0032-260', '200200335', 'Bomba de succión', 'SIEMENS', 'FE1500L', '11092', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (261.0, 'INT-GAMB-EFLU-PLA261', '18010-0001-261', '200602941', 'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333759', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (262.0, 'INT-GAMB-EFLU-PLA262', '18010-0001-262', '200602939', 'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333743', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (263.0, 'INT-GAMB-EFLU-PLA263', '18010-0001-263', '200602826', 'Plancha de agitación', 'Fisher Scientific', 'LAB DISC S1', '03-333749', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (264.0, 'INT-GAMB-EFLU-PLA264', '18010-0001-264', '199712284', 'Plancha de agitación', 'Cole Parmer', '4805', '233721', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (265.0, 'INT-GAMB-EFLU-TER265', '18010-0217-265', '200604388', 'Termohigrómetro', 'Extech', 'Sin Información', 'Q673621', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (266.0, 'INT-GAMB-EFLU-DES266', '18010-0058-266', '200604545', 'Destilador kjeldahl automático', 'SELECTA', 'PN-1430', '471961', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (267.0, 'INT-GAMB-EFLU-DES267', '18010-0058-267', 'Sin Información', 'Destilador kjeldahl automático', 'Gerhardt', 'vopdest 500', '5500260009', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES267', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES267', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-DES267', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (268.0, 'INT-GAMB-EFLU-EQU268', '18990-0000-268', '200604775', 'Equipo de filtración a presión', 'Sin Información', 'Sin Información', 'S520773-1-002', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (269.0, 'INT-GAMB-EFLU-EQU269', '18990-0000-269', 'Sin Información', 'Equipo de purificación de agua', 'Millipore', 'Gradient A10', 'F6JN70138B', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (270.0, 'INT-GAMB-EFLU-EQU270', '18990-0000-270', '199800588', 'Equipo test jarra portátil', 'VELP', 'FPA N/P1011117', '1001271', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (271.0, 'INT-GAMB-EFLU-BAL271', '18010-0025-271', '20130556', 'Balanza analítica', 'OHAUS', 'AV264C', 'B33470229', 'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAL271', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAL271', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-BAL271', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (272.0, 'INT-GAMB-EFLU-BAL272', '18010-0025-272', 'Sin Información', 'Balanza analítica', 'Mettler Toledo', 'ABS204S', '1128222725', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (273.0, 'INT-GAMB-EFLU-EQU273', '18990-0000-273', '199711006', 'Equipo test jarra portátil', 'VELP', 'FP4', '3970102', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (274.0, 'INT-GAMB-EFLU-GEN274', '18990-0000-274', 'Sin Información', 'Generador de aire zero', 'PACKARD', '2500', '412711', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (275.0, 'INT-GAMB-EFLU-ESP275', '18010-0086-275', '199711034', 'Espectrofotómetro portátil', 'HACH', 'DR/ 2010', '970500003241', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-ESP275', 1.0, 5.0, 4.0, 1.0, 1.0, 22.0, 22.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-ESP275', 1.0, 1.0, 2.0, 3.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-ESP275', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (276.0, 'INT-GAMB-EFLU-MED276', '18010-0145-276', '20131154', 'medidor de ph', 'sensorex', 'sensolab pm 1000', 'pm 1000-0164', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-MED276', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-MED276', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-MED276', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (277.0, 'INT-GAMB-EFLU-INC277', '18010-0123-277', '199800042', 'Incubador para equipo BOD', 'HACH', 'AR366KMVV', '970803043', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (278.0, 'INT-GAMB-EFLU-INC278', '18010-0123-278', '200601490', 'Incubadora para BOD', 'Felisa', 'FE-145', '506134', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-INC278', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-INC278', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-INC278', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (279.0, 'INT-GAMB-EFLU-MUE279', '18990-0000-279', '200601491', 'Muestreador automático', 'Masterflex', 'Sin Información', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'BAJA', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (280.0, 'INT-GAMB-EFLU-MUF280', '18010-0158-280', '200604546', 'Mufla', 'NABERTHERM', 'L 9/11/B170', '183443', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (281.0, 'INT-GAMB-EFLU-NEV281', '18010-0159-281', '200604386', 'Nevera', 'Sin Información', 'Sin Información', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (282.0, 'INT-GAMB-EFLU-NEV282', '18010-0159-282', '20131155', 'neverA', 'Samnsung', 'B00S9', 'Sin Información', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (283.0, 'INT-GAMB-EFLU-OZO283', '18990-0000-283', '200601513', 'Ozonador', 'OREC', 'LAB21', '1420922', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (284.0, 'INT-GAMB-EFLU-REA284', '18990-0000-284', '199800001', 'Reactor de DQO', 'HACH', '45600', '980400017495', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Sin Información', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REA284', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REA284', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REA284', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (285.0, 'INT-GAMB-EFLU-REC285', '18010-0081-285', '200603561', 'Recirculador de Agua', 'Selecta', 'Frigiterm', '549239', 'Efluentes (Tratabilidad de Efluentes)', 'alta', 'Aparato Auxiliar', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REC285', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REC285', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-REC285', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (286.0, 'INT-GAMB-EFLU-REC286', '18010-0081-286', '199711054', 'Recirculador de agua', 'Neslab', 'RTE100', '194230068', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (287.0, 'INT-GAMB-EFLU-REC287', '18010-0081-287', '200602825', 'Recirculador de agua', 'Thermo Scientific', 'HAAKE A28', '110154012', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (288.0, 'INT-GAMB-EFLU-TIT288', '18010-0156-288', '200601488', 'Titulador automático con agitador', 'Methrom', '775 Dosimat', '10240945', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (289.0, 'INT-GAMB-EFLU-TIT289', '18010-0156-289', '200601489', 'Titulador automático con agitador', 'Methrom', '775 Dosimat', '112140104', 'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (290.0, 'INT-GAMB-EFLU-TIT290', '18010-0156-290', '200601489', 'Titulador automático con agitador', 'Methrom', '775 Dosimat', '112140104', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (291.0, 'INT-GAMB-EFLU-TIT291', '18010-0156-291', '200601488', 'Titulador automático con agitador', 'Methrom', '775 Dosimat', '10240905', 'Efluentes (Tratabilidad de Efluentes)', 'Media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (292.0, 'INT-GAMB-EFLU-TER292', '18010-0217-292', '200604389', 'Termohigrómetro', 'Extech', 'SD700', 'Q673537', 'Efluentes (Tratabilidad de Efluentes)', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-EFLU-TER292', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-EFLU-TER292', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-EFLU-TER292', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Sin Decisión Asignada', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (293.0, 'INT-GAMB-EFLU-TIT293', '18010-0156-293', '200200091', 'Titulador automático con agitador', 'METHROM', 'DOSIMAT 665', '16490030', 'Efluentes (Tratabilidad de Efluentes)', 'Baja', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (294.0, 'INT-GAMB-EFLU-ULT294', '18990-0000-294', '200600962', 'Ultrasonido', 'Selecta', 'UB1488', '474073', 'Efluentes (Tratabilidad de Efluentes)', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (295.0, 'INT-GAMB-EFLU-ULT295', '18990-0000-295', '200600959', 'Ultrasonido', 'Selecta', 'ULTRASONS', '3000910', 'Efluentes (Tratabilidad de Efluentes)', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (296.0, 'INT-GAMB-EFLU-UNI296', '18010-0063-296', '200604544', 'Unidad de digestión', 'SELECTA', 'BLOC DIGEST 12', '464720', 'Efluentes (Tratabilidad de Efluentes)', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (297.0, 'INT-GAMB-QUÍM-ASP297', '18990-0000-297', '199711080', 'Aspiradora', 'GOLDSTAR', 'V-2800TE', '701KB00198', 'Química Ambiental', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (298.0, 'INT-GAMB-QUÍM-BAÑ298', '18990-0000-298', '19971103', 'Baño de ultrasonido', 'COLE-PARMER', '8893', '8893-DTH', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (299.0, 'INT-GAMB-QUÍM-ANA299', '18010-0009-299', 'Sin Información', 'Analizador de hidrocarburos', 'SITELAB', 'TD-3100', '31-0187', 'Química Ambiental', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (300.0, 'INT-GAMB-QUÍM-ANA300', '18010-0009-300', '200603287', 'Analizador de Mercurio', 'TELEDYNE LEEMAN LABS', 'Hydra II AA', '3091', 'Química Ambiental', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ANA300', 1.0, 5.0, 4.0, 2.0, 4.0, 26.0, 26.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ANA300', 1.0, 2.0, 1.0, 2.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ANA300', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (301.0, 'INT-GAMB-QUÍM-DES301', '18990-0000-301', 'Sin Información', 'Desionizador de agua', 'BARNSTEAD', 'D2', '681931119331', 'Química Ambiental', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (302.0, 'INT-GAMB-QUÍM-DES302', '18010-0058-302', 'Sin Información', 'Destilador de agua', 'BARNSTEAD', 'MP-1', '798051222025', 'Química Ambiental', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (303.0, 'INT-GAMB-QUÍM-EQU303', '18990-0000-303', '200200337', 'Equipo de rodillos para cultivo', 'WHEATON', '348921UL', 'I01563', 'Química Ambiental', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (304.0, 'INT-GAMB-QUÍM-ESP304', '18010-0087-304', '200601801', 'Espectrómetro De Plasma (ICP-OES)', 'TELEDYNE LEEMAN LABS', 'PRODIGY', '8019', 'Química Ambiental', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (305.0, 'INT-GAMB-QUÍM-ESP305', '18010-0086-305', 'Sin Información', 'Espectofotometro', 'HACH', 'DR2800', '1179229', 'Química Ambiental', 'ALTA', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (306.0, 'INT-GAMB-QUÍM-ESP306', '18010-0086-306', 'Sin Información', 'espectofotometro UV visible', 'Analytikjena', 'SPECORD 210 PLUS', '223F1729F', 'Química Ambiental', 'Ata', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP306', 1.0, 5.0, 2.0, 1.0, 1.0, 12.0, 12.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP306', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP306', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (307.0, 'INT-GAMB-QUÍM-ESP307', '18010-0087-307', 'Sin Información', 'Espectrómetro De Plasma (ICP-OES)', 'TELEDYNE LEEMAN LABS', 'PRODIGY', '3046', 'Química Ambiental', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP307', 2.0, 10.0, 4.0, 3.0, 4.0, 47.0, 94.0, 'Nivel B (Medio - Semicrítico)', 'Selección Condicionada (Pasa a Evaluación)', 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs>66%)');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP307', 3.0, 3.0, 1.0, 2.0, 9.0, 75.0, 'Obsolescencia Crítica');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-ESP307', 6.25, 'Riesgo Alto', 9.0, 'Oportunidad Prioritaria', 'CRÍTICO EXTREMO', 'Sustitución Inmediata', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (308.0, 'INT-GAMB-QUÍM-IMP308', '18990-0000-308', 'Sin Información', 'impresora', 'HP', 'deskjet 2875', 'BR45LBG1NF', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (309.0, 'INT-GAMB-QUÍM-MOL309', '18010-0155-309', '200601772', 'Molino analítico', 'IKA-WERKE', 'M20', '03-269165', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (310.0, 'INT-GAMB-QUÍM-MON310', '18990-0000-310', 'Sin Información', 'MONITOR', 'DELL', 'P2012Ht', 'CN-0W5HWR-74445-342-C4DS', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (311.0, 'INT-GAMB-QUÍM-MON311', '18990-0000-311', 'Sin Información', 'MONITOR', 'DELL', 'P2012Ht', 'CN-0W5HWR-74445-312-A24L', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (312.0, 'INT-GAMB-QUÍM-MON312', '18990-0000-312', 'Sin Información', 'monitor', 'HP', 'Sin Información', 'CNK4400P7C', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (313.0, 'INT-GAMB-QUÍM-MUF313', '18010-0158-313', '200200382', 'Mufla de mesa', 'LINDBERG/BLUE', 'BF51828C-1', 'R18M-578553-RM', 'Química Ambiental', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (314.0, 'INT-GAMB-QUÍM-NEB314', '18990-0000-314', 'Sin Información', 'Nebulizador neumático', 'CETAC', 'MARIN-5', '071301MR5', 'Química Ambiental', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (315.0, 'INT-GAMB-QUÍM-PC315', '18990-0000-315', 'Sin Información', 'PC', 'DELL', 'OPTIPLEX 3010', '603DP60003G30131795VLA2', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (316.0, 'INT-GAMB-QUÍM-PC316', '18990-0000-316', 'Sin Información', 'PC', 'DELL', 'OPTIPLEX 3010', '603DP60001G23314785VLA0', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (317.0, 'INT-GAMB-QUÍM-PC317', '18990-0000-317', 'Sin Información', 'PC', 'INTEL CORE', 'Sin Información', '2MO421378J', 'Química Ambiental', 'alta', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (318.0, 'INT-GAMB-QUÍM-PUR318', '18010-0096-318', 'Sin Información', 'purificador de agua', 'MEMBRAPURE GmbH', 'AQUINITY P11', 'RW 250606', 'Química Ambiental', 'media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (319.0, 'INT-GAMB-QUÍM-ANA319', '18010-0009-319', 'Sin Información', 'Analizador de hidrocarburos', 'SITELAB', 'TD-3100', '31-0188', 'Química Ambiental', 'media', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (320.0, 'INT-GAMB-QUÍM-BAL320', '18010-0025-320', 'Sin Información', 'Balanza Analítica', 'OHAUS', 'PIONEER PA313', '8331140070', 'Química Ambiental', 'media', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-BAL320', 2.0, 5.0, 2.0, 1.0, 1.0, 12.0, 24.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-BAL320', 1.0, 3.0, 1.0, 2.0, 7.0, 58.33, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-BAL320', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (321.0, 'INT-GAMB-QUÍM-BAL321', '18010-0025-321', 'Sin Información', 'Balanza Analítica', 'OHAUS', 'ADVENTURE PRO AV264C', '8031201114', 'Química Ambiental', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (322.0, 'INT-GAMB-QUÍM-BAL322', '18010-0025-322', 'Sin Información', 'Balanza electrónica', 'PRECISA', 'XB 6200D', '83132', 'Química Ambiental', 'Baja', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (323.0, 'INT-GAMB-QUÍM-BAÑ323', '18010-0027-323', '200200384', 'Baño termostático', 'FISHER SCIENTIFIC', 'ISOTEMP 215', '204N0055', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (324.0, 'INT-GAMB-QUÍM-CEN324', '18010-0042-324', 'Sin Información', 'Centrífuga de mesa', 'FISHER SCIENTIFIC', '228', '1624060540269', 'Química Ambiental', 'Baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (325.0, 'INT-GAMB-QUÍM-CON325', '18990-0000-325', '199711102', 'Concentrador', 'ZYMARK', 'Turbo Vap II', '4020', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (326.0, 'INT-GAMB-QUÍM-PH 326', '18010-0145-326', 'Sin Información', 'Ph metro / conductimetro', 'APERA Instument', 'PC 910', '1220361004', 'Química Ambiental', 'alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-PH 326', 2.0, 5.0, 1.0, 1.0, 1.0, 7.0, 14.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-PH 326', 1.0, 2.0, 1.0, 1.0, 5.0, 41.67, 'Obsolescencia Baja');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-PH 326', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (327.0, 'INT-GAMB-QUÍM-SIS327', '18990-0000-327', '200604402', 'Sistema de reacción asistida por microondas', 'CEM', 'MARSXPRESS', 'MD5056', 'Química Ambiental', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (328.0, 'INT-GAMB-QUÍM-EST328', '18010-0092-328', '199711098', 'Estufa', 'MEMMERT', '50', '810023', 'Química Ambiental', 'media', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (329.0, 'INT-GAMB-QUÍM-SIS329', '18990-0000-329', '200100067', 'Sistema de reacción asistida por microondas', 'CEM', 'MARS 5', 'MD7162', 'Química Ambiental', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (330.0, 'INT-GAMB-QUÍM-PLA330', '18010-0001-330', 'Sin Información', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'FISHER SCIENTIFIC', 'ISOTEMP', 'C1892101142707', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (331.0, 'INT-GAMB-QUÍM-PLA331', '18010-0001-331', 'Sin Información', 'PLANCHA DE AGITACION Y CALENTAMIENTO', 'THERMOLYNE', 'CIMAREC 3', '612911018012', 'Química Ambiental', 'baja', 'Aparato Auxiliar', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (332.0, 'INT-GAMB-QUÍM-ESP332', '18010-0086-332', '20130265', 'Espectrofotómetro UV-VIS', 'AGILENT', 'Sin Información', '8453', 'Química Ambiental', 'Sin Información', 'Sin Información', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;


    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (333.0, 'INT-GAMB-QUÍM-TER333', '18010-0217-333', '200604399', 'Termohigrómetro digital', 'Extech instrument', 'SD700', 'Q668937', 'Química Ambiental', 'Alta', 'Instrumento de Medición', TRUE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-TER333', 4.0, 5.0, 1.0, 1.0, 1.0, 7.0, 28.0, 'Nivel C (Bajo - No Crítico)', 'Exclusión (Mantenimiento Rutinario)', 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico');
    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-TER333', 1.0, 2.0, 1.0, 2.0, 6.0, 50.0, 'Obsolescencia Media');
    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, 'INT-GAMB-QUÍM-TER333', NULL, 'N/A', NULL, 'N/A', 'RIESGOS NO EVALUADOS', 'Gestión por Mantenimiento Rutinario', 'N/A', NULL, NULL, NULL, NULL, NULL, NULL);

    INSERT INTO activos (num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, criticidad_analista, tipo_equipo, pareto_20)
    VALUES (334.0, 'INT-GAMB-QUÍM-TER334', '18010-0217-334', 'Sin Información', 'Termohigrómetro digital', 'Extech instrument', 'SD700', 'Q668939', 'Química Ambiental', 'alta', 'Instrumento de Medición', FALSE)
    ON CONFLICT (tag_pdvsa) DO UPDATE SET nombre = EXCLUDED.nombre
    RETURNING id INTO v_act_id;

END $$;