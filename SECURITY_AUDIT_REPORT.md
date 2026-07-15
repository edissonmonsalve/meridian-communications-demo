# Security Audit Report — Meridian Communications Demo

Fecha: 2026-07-15. Auditoría completa desde cero (no se asumió nada de
revisiones anteriores). Cubre: árbol de trabajo actual, historial completo
de git (`git log --all -p`), todas las ramas y tags, todos los archivos
alguna vez borrados, el workflow de GitHub Actions, y todos los tipos de
archivo pedidos (no se encontró ningún `.env`, `.key`, `.pem`, `.crt`,
`.pfx`, imagen, PDF ni ZIP en todo el repositorio).

## Metodología

- Búsqueda por patrones (no solo texto exacto) con `ripgrep` sobre:
  formatos reales de credenciales (`gho_`, `ghp_`, `github_pat_`, `sk-`,
  `AKIA`, IDs de sesión de Salesforce, tokens Slack), y sobre palabras
  clave genéricas (token, password, secret, auth, credential, session,
  oauth, jwt, bearer, client_secret, api_key, private_key, certificate).
- Búsqueda de identificadores internos específicos del proyecto (EPAM,
  NEORIS, Telecom Argentina, wintestpv, amsuat2, SITWIN, HOTFIX,
  uatcadams2, certprod, Prodmigra, WIN_, proveedor.personal, proveedor.teco).
- Búsqueda de datos personales reales (emails, usernames de Salesforce,
  URLs de perfiles reales en Fiverr/Upwork/LinkedIn).
- `git log --all -p` completo (no solo el estado actual) para capturar
  cualquier cosa que haya existido y luego se haya editado o borrado.
- `git log --all --diff-filter=D --name-only` para listar cada archivo
  borrado alguna vez, e inspección de su contenido histórico.
- `git branch -a` / `git tag` para confirmar el alcance real del historial.
- Revisión manual de `.gitignore` y de `.github/workflows/ci.yml`.

## Hallazgos

| #   | Riesgo                                                                                                                                                                                                                                                                                                                                                | Severidad                      | Archivo                                                                        | Línea                       | Acción correctiva                                                                                                                                                                                                                                                                                                                                | Estado       |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------ | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| 1   | `MARKETING/` contenía datos reales e identificables del negocio personal del usuario (un slug real de gig de Fiverr y un identificador real de perfil de Upwork -- valores reales deliberadamente no reproducidos en este informe) — no era contenido de la empresa ficticia Meridian, no debía estar en un repo público pensado para atraer clientes | **Alta**                       | `MARKETING/Fiverr/README.md`, `MARKETING/Upwork/README.md`, y las 34 restantes | —                           | Carpeta desvinculada del tracking (`git rm --cached`), agregada a `.gitignore` (sigue en disco localmente). Purgada de **todo** el historial de git vía `git filter-branch --index-filter`, backup refs eliminados, `git gc --prune=now` ejecutado, y force-push realizado -- todo con autorización explícita del usuario para este paso puntual | ✅ Corregido |
| 2   | `FINAL_RELEASE.md` mencionaba "EPAM" (empleador real) por nombre, violando la regla propia del proyecto de nunca exponer el empleador en contenido de cara al portfolio                                                                                                                                                                               | Media                          | `FINAL_RELEASE.md`                                                             | 16, 112 (antes de corregir) | Texto generalizado a "un tercero"                                                                                                                                                                                                                                                                                                                | ✅ Corregido |
| 3   | CI workflow (`ci.yml`) dispara sobre la rama `main`, pero la rama real es `master` — el pipeline nunca se ejecutaría                                                                                                                                                                                                                                  | Baja (funcional, no seguridad) | `.github/workflows/ci.yml`                                                     | 12, 14                      | Cambiado a `master`                                                                                                                                                                                                                                                                                                                              | ✅ Corregido |

## Verificado limpio (sin hallazgos)

- **Credenciales de cualquier tipo**: cero tokens, API keys, private keys,
  certificados, client secrets, contraseñas, bearer tokens o session IDs
  reales en ningún archivo del árbol de trabajo ni en ningún commit del
  historial completo.
- **Archivos sensibles**: cero archivos `.env`, `.key`, `.pem`, `.crt`,
  `.pfx`, `.p12`, o con "credentials"/"secret" en el nombre, en ningún
  punto de la historia (ni siquiera transitoriamente).
- **`.gitignore`**: correctamente excluye `.sf/`, `.sfdx/`, `.env`, logs,
  y nunca se detectó que alguno de esos paths haya sido trackeado antes
  de existir el `.gitignore`.
- **`.github/workflows/ci.yml`**: usa `${{ secrets.SFDX_AUTH_URL }}`
  correctamente (referencia a GitHub Actions Secret, nunca un valor
  literal), y borra el archivo temporal con el auth URL inmediatamente
  después de usarlo.
- **Identificadores internos de Telecom Argentina/WIN** (SITWIN, HOTFIX,
  wintestpv, amsuat2, uatcadams2, certprod, Prodmigra, dominios internos,
  IPs internas): cero apariciones reales — las únicas 2 menciones de esos
  términos en todo el repo están en `ARCHITECTURE.md`, y son exactamente
  la lista de identificadores que el proyecto declara **nunca** usar (el
  disclaimer, no una filtración).
- **Datos personales**: cero emails reales, cero usernames reales de
  Salesforce, cero URLs de perfiles reales de LinkedIn en ningún archivo
  del repo (más allá de lo ya cubierto en el hallazgo #1 de `MARKETING/`).
- **Ramas y tags**: una sola rama (`master`), cero tags — sin superficie
  oculta adicional que auditar.
- **Archivos alguna vez borrados**: solo 2 en toda la historia
  (`Account/fields/Type.field-meta.xml`, `Case/fields/Priority.field-meta.xml`)
  — contenido verificado como valores de picklist ficticios del modelo de
  datos, sin ninguna información sensible.
- **Imágenes, PDFs, ZIPs, videos**: no existe ninguno en el repositorio
  (consistente con que la evidencia real —screenshots/video— nunca se
  llegó a capturar, según `FINAL_RELEASE.md`).

## Resultado

**Critical: 0 · High: 0 · Medium: 0 (1 encontrado, resuelto) · Low: 0 (1
encontrado, resuelto)**

**Cumple el criterio de "Critical: 0, High: 0".** Los 3 hallazgos fueron
corregidos y verificados: el hallazgo Alto requirió reescribir el
historial completo de git (autorizado explícitamente por el usuario para
ese paso puntual, dado que excedía la instrucción general de
"eliminar/regenerar documentación"), confirmado con una segunda pasada de
búsqueda sobre `git log --all -p` después de la reescritura y la
recolección de basura (`git gc --prune=now`).
