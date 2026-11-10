import json

with open('sga_data_backup_test.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Keep system configuration and structure, but purge mock/test data
clean_data = {
    "metadata": {
        "version": "2.1.0",
        "sistema": "Sistema Integrado de Gestión de Activos Físicos (SIGAF)",
        "normas": [
            "ISO 55001:2024",
            "PDVSA MM-02-01-01",
            "SUDEBIP/LOBP",
            "ISO/IEC 17025:2017",
            "ISO 10012:2003",
            "LOPCYMAT"
        ],
        "fecha_generacion": "2026-11-08",
        "total_activos": 0,
        "estado": "DEPURADO_ESPERANDO_NUEVA_DATA"
    },
    "usuarios": data.get("usuarios", []),
    "permisos_roles": data.get("permisos_roles", {}),
    "catalogos": data.get("catalogos", {}),
    "activos": [],
    "catalogo_sudebip": [],
    "calibraciones": [],
    "mantenimientos": [],
    "comprobaciones": [],
    "depreciaciones": [],
    "movimientos_sudebip": [],
    "kpis_sga_fo017": [],
    "deriva_fo018": [],
    "acuerdos_fo019": [],
    "brechas_fo030": []
}

with open('sga_data.json', 'w', encoding='utf-8') as f:
    json.dump(clean_data, f, ensure_ascii=False, indent=2)

print("sga_data.json has been purged successfully!")

