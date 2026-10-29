import React, { useState, useEffect } from 'react';
import { Navbar } from './components/Navbar';
import { DashboardView } from './components/DashboardView';
import { InventoryView } from './components/InventoryView';
import { StrategicDecisionsView } from './components/StrategicDecisionsView';
import { MaintenanceView } from './components/MaintenanceView';
import { AssetFormModal } from './components/AssetFormModal';
import { EvaluationWizardModal } from './components/EvaluationWizardModal';
import { SupabaseModal } from './components/SupabaseModal';
import { ActivoFisico, SudebipItem, HistorialFalla, UserRole } from './types';
import { supabase, isSupabaseConfigured } from './lib/supabase';
import initialData from '../sga_data.json';

export default function App() {
  const [currentTab, setCurrentTab] = useState<'dashboard' | 'inventory' | 'decisions' | 'maintenance'>('dashboard');
  const [userRole, setUserRole] = useState<UserRole>('analista');
  const [isWizardOpen, setIsWizardOpen] = useState(false);

  const [activos, setActivos] = useState<ActivoFisico[]>(() => {
    const cached = localStorage.getItem('sgaf_activos_data');
    if (cached) {
      try {
        const parsed = JSON.parse(cached);
        if (Array.isArray(parsed) && parsed.length > 0) {
          return parsed;
        }
      } catch (e) {
        console.error('Error parsing cached data', e);
      }
    }
    return (initialData as any)?.activos || [];
  });

  const [catalogoSudebip, setCatalogoSudebip] = useState<SudebipItem[]>(
    (initialData as any).catalogo_sudebip || []
  );

  const [selectedActivo, setSelectedActivo] = useState<ActivoFisico | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [isSupabaseModalOpen, setIsSupabaseModalOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // Sync with Supabase if configured
  useEffect(() => {
    if (!isSupabaseConfigured || !supabase) return;

    const fetchFromSupabase = async () => {
      setIsLoading(true);
      try {
        const { data, error } = await supabase
          .from('activos')
          .select(`
            *,
            jerarquizacion:jerarquizacion_criticidad(*),
            obsolescencia:evaluacion_obsolescencia(*),
            decision:decisiones_estrategicas(*),
            historial_fallas(*)
          `)
          .order('num', { ascending: true });

        if (error) {
          console.error('Error fetching from Supabase:', error);
        } else if (data && data.length > 0) {
          const formatted = data.map((item: any) => ({
            ...item,
            jerarquizacion: Array.isArray(item.jerarquizacion) ? item.jerarquizacion[0] : item.jerarquizacion,
            obsolescencia: Array.isArray(item.obsolescencia) ? item.obsolescencia[0] : item.obsolescencia,
            decision: Array.isArray(item.decision) ? item.decision[0] : item.decision,
            historial_fallas: item.historial_fallas || []
          }));
          setActivos(formatted);
          localStorage.setItem('sgaf_activos_data', JSON.stringify(formatted));
        }
      } catch (err) {
        console.error('Supabase exception:', err);
      } finally {
        setIsLoading(false);
      }
    };

    fetchFromSupabase();
  }, []);

  // Save asset (either in Supabase or local state)
  const handleSaveActivo = async (updated: ActivoFisico) => {
    const index = activos.findIndex(a => a.tag_pdvsa === updated.tag_pdvsa);
    let newActivos: ActivoFisico[];
    if (index >= 0) {
      newActivos = [...activos];
      newActivos[index] = updated;
    } else {
      newActivos = [updated, ...activos];
    }

    setActivos(newActivos);
    localStorage.setItem('sgaf_activos_data', JSON.stringify(newActivos));

    // Update in Supabase if configured
    if (isSupabaseConfigured && supabase) {
      try {
        const { data: actData, error: actErr } = await supabase
          .from('activos')
          .upsert({
            tag_pdvsa: updated.tag_pdvsa,
            codigo_sudebip: updated.codigo_sudebip,
            codigo_sap: updated.codigo_sap,
            nombre: updated.nombre,
            marca: updated.marca,
            modelo: updated.modelo,
            serial: updated.serial,
            laboratorio: updated.laboratorio,
            criticidad_analista: updated.criticidad_analista,
            tipo_equipo: updated.tipo_equipo,
            pareto_20: updated.pareto_20,
            estado_operativo: updated.estado_operativo,
            rango_medicion: updated.rango_medicion,
            resolucion: updated.resolucion,
            frecuencia_calibracion: updated.frecuencia_calibracion,
            fecha_ultima_calibracion: updated.fecha_ultima_calibracion || null,
            fecha_proxima_calibracion: updated.fecha_proxima_calibracion || null
          }, { onConflict: 'tag_pdvsa' })
          .select('id')
          .single();

        if (actErr) {
          console.error('Error saving to Supabase:', actErr);
        } else if (actData?.id) {
          const actId = actData.id;

          if (updated.jerarquizacion) {
            await supabase.from('jerarquizacion_criticidad').upsert({
              activo_id: actId,
              tag_pdvsa: updated.tag_pdvsa,
              ff: updated.jerarquizacion.ff,
              io: updated.jerarquizacion.io,
              fo: updated.jerarquizacion.fo,
              cm: updated.jerarquizacion.cm,
              sha: updated.jerarquizacion.sha,
              consecuencia: updated.jerarquizacion.consecuencia,
              ic: updated.jerarquizacion.ic,
              categoria_criticidad: updated.jerarquizacion.categoria_criticidad,
              estatus_seleccion: updated.jerarquizacion.estatus_seleccion,
              criterio_accion: updated.jerarquizacion.criterio_accion
            });
          }

          if (updated.obsolescencia) {
            await supabase.from('evaluacion_obsolescencia').upsert({
              activo_id: actId,
              tag_pdvsa: updated.tag_pdvsa,
              eol: updated.obsolescencia.eol,
              rep: updated.obsolescencia.rep,
              met: updated.obsolescencia.met,
              ant: updated.obsolescencia.ant,
              suma_puntos: updated.obsolescencia.suma_puntos,
              iobs: updated.obsolescencia.iobs,
              estatus_obsolescencia: updated.obsolescencia.estatus_obsolescencia
            });
          }

          if (updated.decision) {
            await supabase.from('decisiones_estrategicas').upsert({
              activo_id: actId,
              tag_pdvsa: updated.tag_pdvsa,
              nivel_riesgo: updated.nivel_riesgo,
              resultado_cruce: updated.resultado_cruce,
              decision_sugerida_riesgo: updated.decision.decision_sugerida_riesgo,
              decision_estrategica_final: updated.decision.decision_estrategica_final,
              responsable_de: updated.decision.responsable_de,
              fecha_estimada_de: updated.decision.fecha_de || null,
              decision_operativa: updated.decision.decision_operativa,
              responsable_do: updated.decision.responsable_do,
              fecha_estimada_do: updated.decision.fecha_do || null
            });
          }
        }
      } catch (err) {
        console.error('Error in Supabase upsert:', err);
      }
    }
  };

  // Update fallas / maintenance orders for an asset
  const handleUpdateActivoFallas = async (tag_pdvsa: string, fallas: HistorialFalla[]) => {
    const updated = activos.map(a => {
      if (a.tag_pdvsa === tag_pdvsa) {
        return { ...a, historial_fallas: fallas };
      }
      return a;
    });

    setActivos(updated);
    localStorage.setItem('sgaf_activos_data', JSON.stringify(updated));

    if (isSupabaseConfigured && supabase) {
      const target = activos.find(a => a.tag_pdvsa === tag_pdvsa);
      if (target?.id) {
        try {
          await supabase.from('historial_fallas').delete().eq('tag_pdvsa', tag_pdvsa);
          if (fallas.length > 0) {
            const records = fallas.map(f => ({
              activo_id: target.id,
              tag_pdvsa,
              fecha_evento: f.fecha_evento,
              tipo_evento: f.tipo_evento,
              descripcion: f.descripcion,
              tiempo_fuera_servicio_horas: f.tiempo_fuera_servicio_horas,
              costo_reparacion: f.costo_reparacion || 0,
              tecnico_responsable: f.tecnico_responsable || '',
              impacto_operacional: f.impacto_operacional || '',
              accion_tomada: f.accion_tomada || ''
            }));
            await supabase.from('historial_fallas').insert(records);
          }
        } catch (err) {
          console.error('Error syncing fallas with Supabase:', err);
        }
      }
    }
  };

  const handleOpenDetail = (activo: ActivoFisico) => {
    setSelectedActivo(activo);
    setIsFormOpen(true);
  };

  const handleOpenCreate = () => {
    setSelectedActivo(null);
    setIsFormOpen(true);
  };

  return (
    <div className="min-h-screen bg-slate-100 text-slate-800 flex flex-col font-sans transition-colors duration-200">
      
      {/* Top Navbar */}
      <Navbar
        currentTab={currentTab}
        setCurrentTab={setCurrentTab}
        onOpenSupabaseModal={() => setIsSupabaseModalOpen(true)}
        onOpenWizard={() => setIsWizardOpen(true)}
        totalActivos={activos.length}
        userRole={userRole}
        setUserRole={setUserRole}
      />

      {/* Main Container */}
      <main className="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-6 sm:py-8">
        {currentTab === 'dashboard' && (
          <DashboardView
            activos={activos}
            onSelectActivo={handleOpenDetail}
            onGoToDecisions={() => setCurrentTab('decisions')}
            onOpenWizard={() => setIsWizardOpen(true)}
            onFilterByCriticidad={(nivel) => {
              setCurrentTab('inventory');
            }}
            onFilterByObsolescencia={(nivel) => {
              setCurrentTab('inventory');
            }}
          />
        )}

        {currentTab === 'inventory' && (
          <InventoryView
            activos={activos}
            onSelectActivo={handleOpenDetail}
            onCreateActivo={handleOpenCreate}
          />
        )}

        {currentTab === 'decisions' && (
          <StrategicDecisionsView
            activos={activos}
            onSelectActivo={handleOpenDetail}
          />
        )}

        {currentTab === 'maintenance' && (
          <MaintenanceView
            activos={activos}
            onUpdateActivoFallas={handleUpdateActivoFallas}
          />
        )}
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 bg-white py-5 px-6 text-center text-xs sm:text-sm text-slate-500 font-medium">
        <p className="text-slate-700 font-bold">
          SGAF • Sistema Integrado de Gestión de Activos Físicos | Gerencia de Ambiente - PDVSA INTEVEP
        </p>
        <p className="text-xs text-slate-500 mt-1">
          En cumplimiento con ISO 55001:2024, ISO 31000, ISO 10012, SUDEBIP y Normas PDVSA MM-01-01-07 / MM-02-01-01.
        </p>
      </footer>

      {/* Evaluation Wizard Modal (Paso a Paso UX) */}
      <EvaluationWizardModal
        isOpen={isWizardOpen}
        onClose={() => setIsWizardOpen(false)}
        activos={activos}
        onSaveActivo={handleSaveActivo}
        userRole={userRole}
      />

      {/* Full Asset Detail/Form Modal */}
      <AssetFormModal
        isOpen={isFormOpen}
        onClose={() => setIsFormOpen(false)}
        activo={selectedActivo}
        onSave={handleSaveActivo}
        catalogoSudebip={catalogoSudebip}
      />

      {/* Supabase Connection Modal */}
      <SupabaseModal
        isOpen={isSupabaseModalOpen}
        onClose={() => setIsSupabaseModalOpen(false)}
      />

    </div>
  );
}
