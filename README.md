# Sistema de Gestión de Activos Físicos (SGAF)
### Basado en ISO 55001:2024, PDVSA MM-02-01-01, SUDEBIP e ISO 10012

Plataforma web integral para la jerarquización de criticidad de activos, cálculo de obsolescencia tecnológica, homologación con el catálogo nacional de bienes públicos (SUDEBIP) y generación de decisiones estratégicas y operativas (CAPEX / OPEX / Overhaul).

---

## 🚀 Características Principales

- **Convergencia Dual de Codificación**: Homologación entre el código interno de PDVSA (taxonomía técnica y funcional), códigos SAP y el Catálogo de Bienes Públicos de la SUDEBIP.
- **Jerarquización de Criticidad (PDVSA MM-02-01-01)**:
  - Frecuencia de Falla ($FF$)
  - Impacto Operacional ($IO$)
  - Flexibilidad Operacional ($FO$)
  - Costo de Mantenimiento ($CM$)
  - Seguridad, Higiene y Ambiente ($SHA$)
  - Cálculo automático de Consecuencia ($C$) e Índice de Criticidad ($IC$).
- **Índice de Obsolescencia Tecnológica ($I_{obs}$)**:
  - Fin de vida dictaminada por fabricante ($EOL$)
  - Disponibilidad de repuestos e insumos ($REP$)
  - Respaldo y aseguramiento metrológico ($MET - ISO 10012$)
  - Antigüedad / Años de servicio ($ANT$)
- **Matriz Multicriterio de Decisión**:
  - Cuadrante 1: Reemplazo por Obsolescencia Tecnológica (Inversión de Capital - CAPEX).
  - Cuadrante 2: Overhaul Mayor o Extensión de Vida Útil.
  - Cuadrante 3: Mantenimiento Basado en Condición (CBM).
  - Cuadrante 4: Estrategia de Mantenimiento Rutinario y Predictivo.
  - Cuadrante 5: Desincorporación o Venta según lineamientos SUDEBIP.
- **Módulo de Mantenimiento y Fallas (CRUD)**:
  - Control de órdenes preventivas, correctivas, predictivas y calibraciones ISO 10012.
  - Indicadores de indisponibilidad (horas de parada) y costos asociados.
- **Roles de Usuario**:
  - 🧪 Analista de Laboratorio
  - 🔧 Especialista de Mantenimiento
  - 📋 Custodio SUDEBIP / Bienes Públicos
  - 👔 Gerente de Gestión de Activos

---

## 🛠️ Tecnologías Utilizadas

- **Frontend**: React 18, TypeScript, Vite, Tailwind CSS, Lucide Icons, Recharts.
- **Backend / Base de Datos**: Supabase (PostgreSQL con Row Level Security y vistas analíticas).
- **Despliegue**: Optimizado para Vercel.

---

## 📦 Instalación y Ejecución Local

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/alfamil/sistema-proyecto.git
   cd sistema-proyecto
   ```

2. Instalar dependencias:
   ```bash
   npm install
   ```

3. Variables de entorno:
   Copiar `.env.example` a `.env` y configurar las credenciales de Supabase:
   ```env
   VITE_SUPABASE_URL=https://vsjvkjdmxjbzqtzpnroy.supabase.co
   VITE_SUPABASE_ANON_KEY=sb_publishable_786xYEM3cgfif0v_7l9hCg_iAZOZBDV
   ```

4. Iniciar en modo desarrollo:
   ```bash
   npm run dev
   ```

5. Compilar para producción:
   ```bash
   npm run build
   ```

---

## 🌐 Despliegue en Vercel

1. Importar el repositorio desde el panel de Vercel.
2. Vercel detectará automáticamente la configuración **Vite**:
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
3. En la sección **Environment Variables** de Vercel, agregar:
   - `VITE_SUPABASE_URL`: Tu URL del proyecto de Supabase.
   - `VITE_SUPABASE_ANON_KEY`: Tu clave pública publishable de Supabase.
4. Desplegar (`Deploy`).
