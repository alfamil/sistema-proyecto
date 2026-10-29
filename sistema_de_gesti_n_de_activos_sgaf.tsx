import React, { useState, useEffect } from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth, signInAnonymously, signInWithCustomToken, onAuthStateChanged } from 'firebase/auth';
import { getFirestore, collection, query, onSnapshot, addDoc, updateDoc, doc, deleteDoc } from 'firebase/firestore';
import { 
  ShieldCheck, Activity, Settings, AlertTriangle, 
  FileText, Plus, ArrowLeft, Save, Search, 
  Wrench, Hammer, Calendar, CheckCircle, Clock,
  PieChart as PieChartIcon, TrendingUp, Target, List, Lightbulb
} from 'lucide-react';
import { PieChart, Pie, Cell, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, ResponsiveContainer } from 'recharts';

// --- FIREBASE INITIALIZATION ---
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);
const appId = typeof __app_id !== 'undefined' ? __app_id : 'sgaf-lab-app';

// --- COMPONENTS ---

export default function SGAFApp() {
  const [user, setUser] = useState(null);
  const [equipments, setEquipments] = useState([]);
  const [currentView, setCurrentView] = useState('list'); // 'list', 'form', 'detail', 'dashboard'
  const [selectedEq, setSelectedEq] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  // Authentication Effect
  useEffect(() => {
    const initAuth = async () => {
      try {
        if (typeof __initial_auth_token !== 'undefined' && __initial_auth_token) {
          await signInWithCustomToken(auth, __initial_auth_token);
        } else {
          await signInAnonymously(auth);
        }
      } catch (error) {
        console.error("Auth error:", error);
      }
    };
    initAuth();

    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
    });
    return () => unsubscribe();
  }, []);

  // Data Fetching Effect
  useEffect(() => {
    if (!user) return;
    
    setIsLoading(true);
    // Strict Path: collection(db, 'artifacts', appId, 'users', userId, collectionName)
    const eqRef = collection(db, 'artifacts', appId, 'users', user.uid, 'equipments');
    const q = query(eqRef);

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const eqData = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      // Sort in memory (Rule 2: No complex queries)
      eqData.sort((a, b) => b.createdAt - a.createdAt);
      setEquipments(eqData);
      setIsLoading(false);
    }, (error) => {
      console.error("Firestore error:", error);
      setIsLoading(false);
    });

    return () => unsubscribe();
  }, [user]);

  // View Handlers
  const goToList = () => { setCurrentView('list'); setSelectedEq(null); };
  const goToCreate = () => { setSelectedEq(null); setCurrentView('form'); };
  const goToEdit = (eq) => { setSelectedEq(eq); setCurrentView('form'); };
  const goToDetail = (eq) => { setSelectedEq(eq); setCurrentView('detail'); };

  if (!user) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-slate-50">
        <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-100 flex flex-col font-sans text-slate-800">
      {/* Navbar */}
      <header className="bg-slate-900 text-white shadow-md">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
          <div className="flex items-center space-x-3">
            <Activity className="w-8 h-8 text-blue-400" />
            <div>
              <h1 className="text-xl font-bold leading-tight">SGAF Lab</h1>
              <p className="text-xs text-slate-400">Sistema de Gestión de Activos Físicos (SUDEBIP / ISO 55001)</p>
            </div>
          </div>
          <div className="text-sm bg-slate-800 px-3 py-1 rounded-full border border-slate-700 flex items-center">
            <ShieldCheck className="w-4 h-4 mr-2 text-green-400" />
            Usuario Autenticado
          </div>
        </div>
      </header>

      {/* Navigation Tabs */}
      <div className="bg-slate-800 text-slate-300 px-4 sm:px-6 lg:px-8 border-t border-slate-700 shadow-sm">
        <div className="max-w-7xl mx-auto flex space-x-6">
          <button 
            onClick={goToList} 
            className={`py-3 px-2 border-b-2 font-medium text-sm flex items-center transition-colors ${['list', 'form', 'detail'].includes(currentView) ? 'border-blue-400 text-white' : 'border-transparent hover:text-white'}`}
          >
            <List className="w-4 h-4 mr-2" /> Inventario Operativo
          </button>
          <button 
            onClick={() => setCurrentView('dashboard')} 
            className={`py-3 px-2 border-b-2 font-medium text-sm flex items-center transition-colors ${currentView === 'dashboard' ? 'border-blue-400 text-white' : 'border-transparent hover:text-white'}`}
          >
            <PieChartIcon className="w-4 h-4 mr-2" /> Análisis y Dashboard
          </button>
        </div>
      </div>

      {/* Main Content */}
      <main className="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 py-8">
        {currentView === 'list' && (
          <EquipmentList 
            equipments={equipments} 
            onCreate={goToCreate} 
            onView={goToDetail}
            isLoading={isLoading}
          />
        )}
        {currentView === 'form' && (
          <EquipmentForm 
            initialData={selectedEq} 
            onCancel={goToList} 
            user={user}
          />
        )}
        {currentView === 'detail' && (
          <EquipmentDetail 
            equipment={selectedEq} 
            onBack={goToList} 
            onEdit={() => goToEdit(selectedEq)}
            user={user}
          />
        )}
        {currentView === 'dashboard' && (
          <DashboardView equipments={equipments} isLoading={isLoading} />
        )}
      </main>
    </div>
  );
}

// --- SUBCOMPONENTS ---

function EquipmentList({ equipments, onCreate, onView, isLoading }) {
  const [searchTerm, setSearchTerm] = useState('');

  const filtered = equipments.filter(eq => 
    eq.name?.toLowerCase().includes(searchTerm.toLowerCase()) || 
    eq.sudebipCode?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    eq.internalTag?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center space-y-4 sm:space-y-0">
        <h2 className="text-2xl font-semibold text-slate-800">Inventario de Equipos</h2>
        <button 
          onClick={onCreate}
          className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg shadow-sm flex items-center transition-colors"
        >
          <Plus className="w-5 h-5 mr-2" />
          Registrar Equipo
        </button>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
        <div className="p-4 border-b border-slate-200 bg-slate-50 flex items-center">
          <div className="relative flex-1 max-w-md">
            <Search className="w-5 h-5 absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400" />
            <input 
              type="text" 
              placeholder="Buscar por código, TAG o nombre..." 
              className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-100 text-slate-600 text-sm uppercase tracking-wider">
                <th className="p-4 font-medium">Código / TAG</th>
                <th className="p-4 font-medium">Descripción</th>
                <th className="p-4 font-medium">Ubicación</th>
                <th className="p-4 font-medium">Estado</th>
                <th className="p-4 font-medium text-right">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-200">
              {isLoading ? (
                <tr>
                  <td colSpan="5" className="p-8 text-center text-slate-500">Cargando inventario...</td>
                </tr>
              ) : filtered.length === 0 ? (
                <tr>
                  <td colSpan="5" className="p-8 text-center text-slate-500">No se encontraron equipos registrados.</td>
                </tr>
              ) : (
                filtered.map(eq => (
                  <tr key={eq.id} className="hover:bg-slate-50 transition-colors group cursor-pointer" onClick={() => onView(eq)}>
                    <td className="p-4">
                      <div className="font-semibold text-blue-700">{eq.sudebipCode || 'S/C'}</div>
                      <div className="text-xs text-slate-500">{eq.internalTag}</div>
                    </td>
                    <td className="p-4">
                      <div className="font-medium text-slate-800">{eq.name}</div>
                      <div className="text-xs text-slate-500">{eq.brand} - {eq.model}</div>
                    </td>
                    <td className="p-4 text-sm text-slate-600">{eq.location}</td>
                    <td className="p-4">
                      <StatusBadge status={eq.status} />
                    </td>
                    <td className="p-4 text-right">
                      <button 
                        onClick={(e) => { e.stopPropagation(); onView(eq); }}
                        className="text-blue-600 hover:text-blue-800 font-medium text-sm px-3 py-1 bg-blue-50 hover:bg-blue-100 rounded-md transition-colors"
                      >
                        Ver Ficha
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function EquipmentForm({ initialData, onCancel, user }) {
  const [formData, setFormData] = useState(initialData || {
    // Section I
    sudebipCode: '', internalTag: '', name: '', brand: '', model: '', serial: '', location: '', status: 'Operativo',
    // Section II
    measuringRange: '', resolution: '', calibrationFreq: 'Anual', metrologicalClass: 'Equipo de Trabajo',
    // Section III
    capex: '', lifeExpectancy: '', tco: '', startupDate: '',
    // Section IV
    criticality: 'Semicrítico (Clase B)', failureImpact: '',
    logs: [] // Will hold history
  });
  const [isSaving, setIsSaving] = useState(false);
  const [errorMsg, setErrorMsg] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSaving(true);
    setErrorMsg('');

    try {
      const eqRef = collection(db, 'artifacts', appId, 'users', user.uid, 'equipments');
      const payload = { ...formData, updatedAt: Date.now() };

      if (initialData?.id) {
        // Update
        const docRef = doc(db, 'artifacts', appId, 'users', user.uid, 'equipments', initialData.id);
        await updateDoc(docRef, payload);
      } else {
        // Create
        payload.createdAt = Date.now();
        await addDoc(eqRef, payload);
      }
      onCancel(); // Go back
    } catch (error) {
      console.error("Save error:", error);
      setErrorMsg("Error al guardar los datos. Intente de nuevo.");
      setIsSaving(false);
    }
  };

  return (
    <div className="max-w-4xl mx-auto bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
      <div className="bg-slate-50 px-6 py-4 border-b border-slate-200 flex justify-between items-center">
        <h2 className="text-xl font-bold text-slate-800">
          {initialData ? 'Editar Equipo' : 'Registro de Nuevo Equipo (Hoja de Vida)'}
        </h2>
        <button onClick={onCancel} className="text-slate-500 hover:text-slate-700 flex items-center">
          <ArrowLeft className="w-4 h-4 mr-1" /> Volver
        </button>
      </div>

      <form onSubmit={handleSubmit} className="p-6 space-y-8">
        {errorMsg && (
          <div className="bg-red-50 text-red-600 p-4 rounded-lg flex items-center">
            <AlertTriangle className="w-5 h-5 mr-2" /> {errorMsg}
          </div>
        )}

        {/* SECTION I */}
        <section>
          <h3 className="text-lg font-semibold text-blue-800 flex items-center mb-4 border-b pb-2">
            <FileText className="w-5 h-5 mr-2 text-blue-600" />
            I. Identificación Institucional (Control SUDEBIP)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <FormInput label="Código Bien Nacional (SUDEBIP)" name="sudebipCode" value={formData.sudebipCode} onChange={handleChange} placeholder="Ej. 001-BM-2026" required />
            <FormInput label="Código Interno / TAG" name="internalTag" value={formData.internalTag} onChange={handleChange} placeholder="Ej. LAB-001" required />
            <FormInput label="Nombre del Equipo" name="name" value={formData.name} onChange={handleChange} placeholder="Ej. Espectrofotómetro UV-VIS" required />
            <FormInput label="Marca" name="brand" value={formData.brand} onChange={handleChange} />
            <FormInput label="Modelo" name="model" value={formData.model} onChange={handleChange} />
            <FormInput label="Número de Serial" name="serial" value={formData.serial} onChange={handleChange} />
            <FormInput label="Ubicación Física" name="location" value={formData.location} onChange={handleChange} placeholder="Ej. Laboratorio de Fisicoquímica" />
            
            <div className="flex flex-col">
              <label className="text-sm font-medium text-slate-700 mb-1">Estado Físico Actual</label>
              <select name="status" value={formData.status} onChange={handleChange} className="p-2 border border-slate-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                <option value="Operativo">Operativo</option>
                <option value="En Reparación">En Reparación</option>
                <option value="Fuera de Servicio">Fuera de Servicio</option>
                <option value="Desincorporado">Desincorporado</option>
              </select>
            </div>
          </div>
        </section>

        {/* SECTION II */}
        <section>
          <h3 className="text-lg font-semibold text-blue-800 flex items-center mb-4 border-b pb-2">
            <Settings className="w-5 h-5 mr-2 text-blue-600" />
            II. Especificaciones Metrológicas (ISO 10012 / 17025)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <FormInput label="Rango de Medición" name="measuringRange" value={formData.measuringRange} onChange={handleChange} placeholder="Ej. 0.00 a 14.00 pH" />
            <FormInput label="Resolución / Tolerancia" name="resolution" value={formData.resolution} onChange={handleChange} placeholder="Ej. 0.01 pH" />
            
            <div className="flex flex-col">
              <label className="text-sm font-medium text-slate-700 mb-1">Clasificación Metrológica</label>
              <select name="metrologicalClass" value={formData.metrologicalClass} onChange={handleChange} className="p-2 border border-slate-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                <option value="Patrón de Referencia">Patrón de Referencia</option>
                <option value="Equipo de Trabajo">Equipo de Trabajo (Medición)</option>
                <option value="Instrumento Auxiliar">Instrumento Auxiliar (No medición)</option>
              </select>
            </div>
            
            <div className="flex flex-col">
              <label className="text-sm font-medium text-slate-700 mb-1">Frecuencia de Calibración</label>
              <select name="calibrationFreq" value={formData.calibrationFreq} onChange={handleChange} className="p-2 border border-slate-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                <option value="No Aplica">No Aplica</option>
                <option value="Trimestral">Trimestral</option>
                <option value="Semestral">Semestral</option>
                <option value="Anual">Anual</option>
                <option value="Bianual">Bianual</option>
              </select>
            </div>
          </div>
        </section>

        {/* SECTION III */}
        <section>
          <h3 className="text-lg font-semibold text-blue-800 flex items-center mb-4 border-b pb-2">
            <Activity className="w-5 h-5 mr-2 text-blue-600" />
            III. Gestión del Ciclo de Vida y Valor (ISO 55001:2024)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <FormInput label="Fecha Puesta en Marcha" type="date" name="startupDate" value={formData.startupDate} onChange={handleChange} />
            <FormInput label="Costo Adquisición (CAPEX)" type="number" name="capex" value={formData.capex} onChange={handleChange} placeholder="$" />
            <FormInput label="Costo Total Propiedad (TCO)" type="number" name="tco" value={formData.tco} onChange={handleChange} placeholder="$ Estimado" />
            <FormInput label="Vida Útil (Años)" type="number" name="lifeExpectancy" value={formData.lifeExpectancy} onChange={handleChange} />
          </div>
        </section>

        {/* SECTION IV */}
        <section>
          <h3 className="text-lg font-semibold text-blue-800 flex items-center mb-4 border-b pb-2">
            <AlertTriangle className="w-5 h-5 mr-2 text-blue-600" />
            IV. Gestión de Riesgos (Norma PDVSA MM-02-01-01)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div className="flex flex-col">
              <label className="text-sm font-medium text-slate-700 mb-1">Nivel de Criticidad</label>
              <select name="criticality" value={formData.criticality} onChange={handleChange} className="p-2 border border-slate-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                <option value="Crítico (Clase A)">Crítico (Clase A - Impacta producción/seguridad)</option>
                <option value="Semicrítico (Clase B)">Semicrítico (Clase B - Impacto parcial/Disminuye eficiencia)</option>
                <option value="No Crítico (Clase C)">No Crítico (Clase C - Sin impacto directo)</option>
              </select>
            </div>
            <FormInput label="Impacto de la Falla" name="failureImpact" value={formData.failureImpact} onChange={handleChange} placeholder="Ej. Resultados erróneos, retraso de análisis" />
          </div>
        </section>

        <div className="pt-6 border-t border-slate-200 flex justify-end space-x-3">
          <button type="button" onClick={onCancel} className="px-5 py-2 border border-slate-300 rounded-lg text-slate-700 hover:bg-slate-50 transition-colors">
            Cancelar
          </button>
          <button type="submit" disabled={isSaving} className="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg flex items-center shadow-sm disabled:opacity-50 transition-colors">
            <Save className="w-5 h-5 mr-2" />
            {isSaving ? 'Guardando...' : 'Guardar Expediente'}
          </button>
        </div>
      </form>
    </div>
  );
}

function EquipmentDetail({ equipment, onBack, onEdit, user }) {
  const [showLogModal, setShowLogModal] = useState(false);
  const [logForm, setLogForm] = useState({ type: 'Mantenimiento Preventivo', date: '', description: '', technician: '' });

  const obsolescence = calculateObsolescence(equipment.startupDate, equipment.lifeExpectancy);
  const strategy = getStrategicAdvice(equipment, obsolescence);

  const handleSaveLog = async () => {
    if (!logForm.date || !logForm.description) return; // Simple validation
    try {
      const docRef = doc(db, 'artifacts', appId, 'users', user.uid, 'equipments', equipment.id);
      const newLog = { ...logForm, id: Date.now().toString() };
      const updatedLogs = [newLog, ...(equipment.logs || [])];
      
      await updateDoc(docRef, { logs: updatedLogs });
      setShowLogModal(false);
      setLogForm({ type: 'Mantenimiento Preventivo', date: '', description: '', technician: '' });
      // Note: Data won't instantly refresh in detail view without local state update, 
      // but the parent listener updates the main list. We update locally for UX:
      equipment.logs = updatedLogs; 
    } catch (error) {
      console.error("Error saving log", error);
    }
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto">
      {/* Header Actions */}
      <div className="flex justify-between items-center bg-white p-4 rounded-xl shadow-sm border border-slate-200">
        <button onClick={onBack} className="text-slate-600 hover:text-blue-600 flex items-center transition-colors">
          <ArrowLeft className="w-5 h-5 mr-2" /> Volver al Inventario
        </button>
        <button onClick={onEdit} className="text-white bg-slate-800 hover:bg-slate-900 px-4 py-2 rounded-lg text-sm flex items-center transition-colors">
          <Wrench className="w-4 h-4 mr-2" /> Modificar Datos
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column: Specs */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Obsolescence Banner */}
          {obsolescence && (obsolescence.isNear || obsolescence.isObsolete) && (
            <div className={`p-4 rounded-xl shadow-sm flex items-center border ${
              obsolescence.isObsolete 
                ? 'bg-red-50 border-red-200 text-red-800' 
                : 'bg-orange-50 border-orange-200 text-orange-800'
            }`}>
              <AlertTriangle className={`w-8 h-8 mr-4 flex-shrink-0 ${obsolescence.isObsolete ? 'text-red-500' : 'text-orange-500'}`} />
              <div>
                <h4 className="font-bold text-base">
                  {obsolescence.isObsolete 
                    ? '¡Atención! Equipo en Estado de Obsolescencia' 
                    : 'Alerta Preventiva: Vida Útil Próxima a Vencer'}
                </h4>
                <p className="text-sm mt-1">
                  <strong>Índice de Obsolescencia: {obsolescence.index.toFixed(1)}%</strong>. 
                  {obsolescence.isObsolete 
                    ? ` El equipo superó su vida útil estimada el ${obsolescence.endDate}. Se requiere evaluación técnica para desincorporación o repotenciación.` 
                    : ` Planifique su reemplazo o mantenimiento mayor. Fecha de caducidad estimada: ${obsolescence.endDate}.`}
                </p>
              </div>
            </div>
          )}

          {/* Main Info Card */}
          <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
            <div className="flex justify-between items-start mb-6">
              <div>
                <h2 className="text-2xl font-bold text-slate-800">{equipment.name}</h2>
                <div className="flex space-x-3 mt-2 text-sm">
                  <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded font-mono border border-blue-200">
                    SUDEBIP: {equipment.sudebipCode || 'N/A'}
                  </span>
                  <span className="bg-slate-100 text-slate-700 px-2 py-1 rounded font-mono border border-slate-200">
                    TAG: {equipment.internalTag || 'N/A'}
                  </span>
                </div>
              </div>
              <StatusBadge status={equipment.status} />
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-3 gap-6 mb-6">
              <DetailItem label="Marca" value={equipment.brand} />
              <DetailItem label="Modelo" value={equipment.model} />
              <DetailItem label="Serial" value={equipment.serial} />
              <DetailItem label="Ubicación" value={equipment.location} />
              <DetailItem label="Criticidad" value={equipment.criticality} />
            </div>
          </div>

          {/* Metrology & Lifecycle Card */}
          <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
            <div className="bg-slate-50 border-b border-slate-200 p-4">
              <h3 className="font-semibold text-slate-800">Especificaciones Metrológicas y Ciclo de Vida</h3>
            </div>
            <div className="p-6 grid grid-cols-1 sm:grid-cols-2 gap-y-6 gap-x-8">
              <div>
                <h4 className="text-sm font-semibold text-blue-700 mb-3 border-b pb-1">Metrología</h4>
                <ul className="space-y-3 text-sm">
                  <li><span className="text-slate-500 block">Rango Medición:</span> {equipment.measuringRange || '-'}</li>
                  <li><span className="text-slate-500 block">Resolución:</span> {equipment.resolution || '-'}</li>
                  <li><span className="text-slate-500 block">Frecuencia Calibración:</span> {equipment.calibrationFreq}</li>
                  <li><span className="text-slate-500 block">Clase:</span> {equipment.metrologicalClass}</li>
                </ul>
              </div>
              <div>
                <h4 className="text-sm font-semibold text-blue-700 mb-3 border-b pb-1">Ciclo de Vida (ISO 55001)</h4>
                <ul className="space-y-3 text-sm">
                  <li><span className="text-slate-500 block">Fecha Inicio:</span> {equipment.startupDate || '-'}</li>
                  <li><span className="text-slate-500 block">Vida Útil:</span> {equipment.lifeExpectancy ? `${equipment.lifeExpectancy} años` : '-'}</li>
                  <li>
                    <span className="text-slate-500 block">Índice Obsolescencia:</span> 
                    {obsolescence ? (
                      <span className={`font-bold ${obsolescence.isObsolete ? 'text-red-600' : obsolescence.isNear ? 'text-orange-600' : 'text-green-600'}`}>
                        {obsolescence.index.toFixed(1)}% 
                      </span>
                    ) : '-'}
                  </li>
                  <li><span className="text-slate-500 block">CAPEX:</span> {equipment.capex ? `$${equipment.capex}` : '-'}</li>
                </ul>
              </div>
            </div>
          </div>

          {/* Strategic Decision Engine */}
          <div className="bg-slate-800 text-white rounded-xl shadow-sm border border-slate-700 overflow-hidden">
            <div className="bg-slate-900 border-b border-slate-700 p-4 flex items-center">
              <Lightbulb className="w-5 h-5 text-yellow-400 mr-2" />
              <h3 className="font-semibold text-slate-100">Inteligencia de Activos: Decisiones Estratégicas y Próximas Acciones</h3>
            </div>
            <div className="p-6">
              <div className="mb-4">
                <span className="text-slate-400 text-xs uppercase tracking-wider block mb-1">Decisión Principal Sugerida</span>
                <span className="text-lg font-bold text-blue-300">{strategy.decision}</span>
              </div>
              <div>
                <span className="text-slate-400 text-xs uppercase tracking-wider block mb-2">Acciones a Ejecutar</span>
                <ul className="space-y-2">
                  {strategy.actions.map((action, idx) => (
                    <li key={idx} className="flex items-start text-sm">
                      <Target className="w-4 h-4 text-blue-400 mr-2 mt-0.5 flex-shrink-0" />
                      <span className="text-slate-200">{action}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column: History Logs */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 flex flex-col h-[600px]">
          <div className="bg-slate-50 border-b border-slate-200 p-4 flex justify-between items-center">
            <h3 className="font-semibold text-slate-800 flex items-center">
              <Clock className="w-4 h-4 mr-2" /> Historial Operativo
            </h3>
            <button 
              onClick={() => setShowLogModal(true)}
              className="text-blue-600 hover:text-blue-800 text-sm font-medium flex items-center"
            >
              <Plus className="w-4 h-4 mr-1" /> Añadir
            </button>
          </div>
          
          <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-slate-50/50">
            {(!equipment.logs || equipment.logs.length === 0) ? (
              <div className="text-center text-slate-500 mt-10 text-sm">
                No hay registros de eventos para este equipo.
              </div>
            ) : (
              equipment.logs.map(log => (
                <div key={log.id} className="bg-white p-3 rounded-lg border border-slate-200 shadow-sm text-sm relative">
                  <div className="absolute top-3 right-3">
                    {log.type.includes('Preventivo') && <CheckCircle className="w-4 h-4 text-green-500" />}
                    {log.type.includes('Correctivo') && <Hammer className="w-4 h-4 text-red-500" />}
                    {log.type.includes('Calibración') && <Settings className="w-4 h-4 text-blue-500" />}
                  </div>
                  <div className="font-medium text-slate-800 mb-1">{log.type}</div>
                  <div className="text-xs text-slate-500 mb-2 flex items-center">
                    <Calendar className="w-3 h-3 mr-1" /> {log.date}
                  </div>
                  <p className="text-slate-700 text-xs mb-2">{log.description}</p>
                  <div className="text-xs text-slate-400 border-t border-slate-100 pt-1">
                    Ejecutado por: {log.technician || 'N/A'}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>

      {/* Add Log Modal */}
      {showLogModal && (
        <div className="fixed inset-0 bg-slate-900/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-md overflow-hidden">
            <div className="bg-slate-50 px-4 py-3 border-b border-slate-200">
              <h3 className="font-semibold text-slate-800">Registrar Evento</h3>
            </div>
            <div className="p-4 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Tipo de Evento</label>
                <select 
                  className="w-full p-2 border border-slate-300 rounded-lg text-sm focus:ring-blue-500 focus:border-blue-500"
                  value={logForm.type} onChange={(e) => setLogForm({...logForm, type: e.target.value})}
                >
                  <option>Mantenimiento Preventivo</option>
                  <option>Mantenimiento Correctivo</option>
                  <option>Calibración / Verificación</option>
                  <option>Inspección de Seguridad</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Fecha</label>
                <input type="date" className="w-full p-2 border border-slate-300 rounded-lg text-sm" 
                  value={logForm.date} onChange={(e) => setLogForm({...logForm, date: e.target.value})} required/>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Descripción del Trabajo</label>
                <textarea className="w-full p-2 border border-slate-300 rounded-lg text-sm h-24 resize-none" 
                  placeholder="Detalles de la intervención..."
                  value={logForm.description} onChange={(e) => setLogForm({...logForm, description: e.target.value})} required></textarea>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">Técnico / Proveedor</label>
                <input type="text" className="w-full p-2 border border-slate-300 rounded-lg text-sm" 
                  value={logForm.technician} onChange={(e) => setLogForm({...logForm, technician: e.target.value})} />
              </div>
            </div>
            <div className="bg-slate-50 px-4 py-3 border-t border-slate-200 flex justify-end space-x-2">
              <button onClick={() => setShowLogModal(false)} className="px-4 py-2 text-sm text-slate-600 hover:bg-slate-100 rounded-lg">Cancelar</button>
              <button onClick={handleSaveLog} className="px-4 py-2 text-sm bg-blue-600 text-white rounded-lg hover:bg-blue-700">Guardar Registro</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// --- DASHBOARD VIEW ---
function DashboardView({ equipments, isLoading }) {
  if (isLoading) return <div className="text-center p-10">Cargando métricas...</div>;
  if (equipments.length === 0) return <div className="text-center p-10 text-slate-500">No hay datos suficientes para el análisis estadístico. Registre equipos primero.</div>;

  // Key Metrics
  const total = equipments.length;
  const operativos = equipments.filter(e => e.status === 'Operativo').length;
  const availability = ((operativos / total) * 100).toFixed(1);
  
  const capexTotal = equipments.reduce((sum, e) => sum + (parseFloat(e.capex) || 0), 0);

  // Status Data
  const statusCounts = equipments.reduce((acc, eq) => {
    acc[eq.status] = (acc[eq.status] || 0) + 1;
    return acc;
  }, {});
  const statusData = Object.keys(statusCounts).map(key => ({ name: key, value: statusCounts[key] }));

  // Criticality Data (PDVSA MM-02-01-01)
  const critCounts = equipments.reduce((acc, eq) => {
    acc[eq.criticality] = (acc[eq.criticality] || 0) + 1;
    return acc;
  }, {});
  const critData = Object.keys(critCounts).map(key => ({ name: key, value: critCounts[key] }));

  // Obsolescence Data
  let obsStats = { optimo: 0, proximo: 0, obsoleto: 0, sin_datos: 0 };
  equipments.forEach(eq => {
    const obs = calculateObsolescence(eq.startupDate, eq.lifeExpectancy);
    if (!obs) obsStats.sin_datos++;
    else if (obs.isObsolete) obsStats.obsoleto++;
    else if (obs.isNear) obsStats.proximo++;
    else obsStats.optimo++;
  });
  const obsData = [
    { name: 'Óptimo (<80%)', value: obsStats.optimo },
    { name: 'Próximo (80-100%)', value: obsStats.proximo },
    { name: 'Obsoleto (>100%)', value: obsStats.obsoleto },
  ];

  const COLORS = ['#10b981', '#f59e0b', '#ef4444', '#64748b', '#3b82f6'];

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-semibold text-slate-800 flex items-center">
        <TrendingUp className="w-6 h-6 mr-3 text-blue-600" />
        Análisis Estadístico de Activos Físicos
      </h2>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex items-center">
          <div className="p-4 rounded-full bg-blue-50 text-blue-600 mr-4">
            <Activity className="w-8 h-8" />
          </div>
          <div>
            <p className="text-sm text-slate-500 uppercase tracking-wider font-semibold">Disponibilidad Planta</p>
            <p className="text-3xl font-bold text-slate-800">{availability}%</p>
          </div>
        </div>
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex items-center">
          <div className="p-4 rounded-full bg-slate-50 text-slate-600 mr-4">
            <List className="w-8 h-8" />
          </div>
          <div>
            <p className="text-sm text-slate-500 uppercase tracking-wider font-semibold">Total Equipos</p>
            <p className="text-3xl font-bold text-slate-800">{total}</p>
          </div>
        </div>
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 flex items-center">
          <div className="p-4 rounded-full bg-green-50 text-green-600 mr-4">
            <TrendingUp className="w-8 h-8" />
          </div>
          <div>
            <p className="text-sm text-slate-500 uppercase tracking-wider font-semibold">Inversión (CAPEX) Total</p>
            <p className="text-3xl font-bold text-slate-800">${capexTotal.toLocaleString()}</p>
          </div>
        </div>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Status Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
          <h3 className="font-semibold text-slate-700 mb-4 text-center">Estado Operativo Global</h3>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={statusData} cx="50%" cy="50%" outerRadius={80} dataKey="value" label>
                  {statusData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <RechartsTooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Criticality Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
          <h3 className="font-semibold text-slate-700 mb-4 text-center">Matriz de Criticidad (Norma PDVSA)</h3>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={critData}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0"/>
                <XAxis dataKey="name" tick={{fontSize: 12}} interval={0} />
                <YAxis allowDecimals={false} />
                <RechartsTooltip cursor={{fill: '#f8fafc'}} />
                <Bar dataKey="value" fill="#3b82f6" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Obsolescence Chart */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 lg:col-span-2">
          <h3 className="font-semibold text-slate-700 mb-4 text-center">Índice de Obsolescencia Institucional (ISO 55001)</h3>
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={obsData.filter(d => d.value > 0)} cx="50%" cy="50%" innerRadius={60} outerRadius={80} dataKey="value" label>
                  <Cell fill="#10b981" /> {/* Óptimo */}
                  <Cell fill="#f59e0b" /> {/* Próximo */}
                  <Cell fill="#ef4444" /> {/* Obsoleto */}
                </Pie>
                <RechartsTooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
}

// --- UTILS ---

function FormInput({ label, name, value, onChange, type = "text", placeholder, required = false }) {
  return (
    <div className="flex flex-col">
      <label className="text-sm font-medium text-slate-700 mb-1">
        {label} {required && <span className="text-red-500">*</span>}
      </label>
      <input 
        type={type} 
        name={name} 
        value={value || ''} 
        onChange={onChange} 
        placeholder={placeholder}
        required={required}
        className="p-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all"
      />
    </div>
  );
}

function DetailItem({ label, value }) {
  return (
    <div>
      <span className="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-1">{label}</span>
      <span className="block text-slate-800 font-medium">{value || 'N/D'}</span>
    </div>
  );
}

function StatusBadge({ status }) {
  const getColors = () => {
    switch(status) {
      case 'Operativo': return 'bg-green-100 text-green-800 border-green-200';
      case 'En Reparación': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'Fuera de Servicio': return 'bg-red-100 text-red-800 border-red-200';
      case 'Desincorporado': return 'bg-slate-200 text-slate-600 border-slate-300';
      default: return 'bg-blue-100 text-blue-800 border-blue-200';
    }
  };
  return (
    <span className={`px-2.5 py-1 rounded-full text-xs font-medium border ${getColors()}`}>
      {status || 'Desconocido'}
    </span>
  );
}

// --- LOGIC HELPERS ---

function calculateObsolescence(startupDate, lifeExpectancyYears) {
  if (!startupDate || !lifeExpectancyYears) return null;
  
  const start = new Date(startupDate);
  const lifeYears = parseFloat(lifeExpectancyYears);
  if (isNaN(start.getTime()) || isNaN(lifeYears)) return null;

  const end = new Date(start);
  end.setFullYear(start.getFullYear() + lifeYears);

  const today = new Date();
  const totalLifespanMs = end.getTime() - start.getTime();
  const elapsedMs = today.getTime() - start.getTime();

  // Si la fecha de puesta en marcha es en el futuro, no ha empezado a consumirse la vida útil
  if (elapsedMs < 0) return { index: 0, isNear: false, isObsolete: false, endDate: end.toLocaleDateString('es-VE') };

  const index = (elapsedMs / totalLifespanMs) * 100;

  return {
    index: index,
    isNear: index >= 80 && index < 100, // Alerta naranja: superó el 80%
    isObsolete: index >= 100,           // Alerta roja: superó el 100%
    endDate: end.toLocaleDateString('es-VE')
  };
}

function getStrategicAdvice(eq, obs) {
  let decision = "Mantenimiento y Operación Estándar";
  let actions = [];

  // Base status analysis
  if (eq.status === 'Desincorporado') {
    return { 
      decision: "Disposición Final de Activo", 
      actions: [
        "Completar expediente y actas exigidas por SUDEBIP.",
        "Ejecutar baja del activo en el sistema contable y patrimonial.",
        "Gestionar disposición final (donación, chatarra, destrucción) según normativas medioambientales (ESG)."
      ] 
    };
  }

  // Obsolescence logic
  if (obs && obs.isObsolete) {
    decision = "Sustitución o Desincorporación Programada";
    actions.push("Iniciar proceso de procura/licitación para reemplazo tecnológico.");
    actions.push("Evaluar repotenciación o 'Retrofit' si el costo de adquisición (CAPEX) actual es limitante.");
    if (eq.criticality.includes('Crítico (Clase A)')) {
      actions.push("¡ALTO RIESGO! Riesgo inminente de parada operativa o afectación de calidad. Prioridad Nivel 1 para reemplazo (Norma PDVSA).");
    }
  } else if (obs && obs.isNear) {
    decision = "Planificación de Reemplazo a Mediano Plazo";
    actions.push("Incluir cotizaciones en el presupuesto del próximo año fiscal.");
    actions.push("Aumentar la frecuencia de mantenimientos preventivos y verificaciones metrológicas para sostener confiabilidad.");
  } else {
    actions.push("Continuar con el plan de mantenimiento preventivo y calibración establecido.");
  }

  // Operational state logic override
  if (eq.status === 'En Reparación') {
    decision = "Recuperación Operativa de Emergencia";
    actions.push("Agilizar la procura de repuestos críticos o presionar al proveedor de servicio externo.");
    if (eq.criticality.includes('Clase A')) {
      actions.push("Activar equipo de respaldo o laboratorio alterno contingente para no afectar la producción/análisis.");
    }
  } else if (eq.status === 'Fuera de Servicio') {
    decision = "Evaluación de Costo de Ciclo de Vida (LCC)";
    actions.push("Determinar si el costo estimado de la reparación supera el 40% del costo actual de un equipo nuevo.");
    actions.push("Si la reparación no es económicamente viable, emitir dictamen técnico para iniciar proceso de desincorporación SUDEBIP.");
  }

  return { decision, actions };
}