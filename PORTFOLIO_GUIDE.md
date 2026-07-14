# Guía de uso del Portfolio — Meridian Communications

Este documento es para vos, no para publicar. Explica qué demuestra cada
captura una vez que existan (ver `PORTFOLIO/screenshots/README.md` para el
checklist de captura, todavía pendiente de un Dev Hub conectado), cuándo
conviene usar cada una, y cómo aprovecharlas en cada canal.

Formato por pantalla: **qué demuestra** → **cuándo usarla** → **para qué
cliente sirve** → **Fiverr** → **Upwork** → **LinkedIn** → **entrevista
técnica**.

---

## 1. Home

**Demuestra:** que sabés armar una app Lightning con navegación coherente
por rol, no solo activar objetos.
**Cuándo:** apertura de un gig o post — es la imagen "de bienvenida", poco
técnica, alta legibilidad.
**Cliente:** cualquiera; es la imagen menos especializada, sirve de gancho.
**Fiverr:** primera imagen de la galería del gig de Salesforce Admin.
**Upwork:** portada del portfolio item.
**LinkedIn:** primera imagen de un carrusel — nunca la única.
**Entrevista:** raramente se usa sola; sirve para orientar antes de entrar
en detalle técnico.

## 2. App Launcher

**Demuestra:** que el org tiene múltiples apps con propósito diferenciado
(Sales / Provisioning / Support), no una sola app genérica con todo mezclado.
**Cuándo:** cuando el pitch es sobre arquitectura multi-equipo o Service
Cloud + Sales Cloud combinados.
**Cliente:** empresas con más de un equipo usando Salesforce (no una startup
de una sola persona).
**Fiverr:** gig de "Salesforce Admin — Enterprise Setup".
**Upwork:** propuestas donde el cliente menciona "múltiples departamentos"
o "diferentes equipos" en su brief.
**LinkedIn:** post sobre diseño de apps por rol.
**Entrevista:** para responder "¿cómo organizás Salesforce para distintos
equipos?" con evidencia, no solo con palabras.

## 3. Object Manager

**Demuestra:** volumen y prolijidad del modelo de datos — labels
consistentes, sin objetos huérfanos ni nombres improvisados.
**Cuándo:** cuando el cliente pregunta "¿cuánto podés construir?" antes de
ver el detalle.
**Cliente:** clientes técnicos que van a mirar la lista y juzgar prolijidad.
**Fiverr:** FAQ del gig ("¿qué incluye un setup Enterprise?").
**Upwork:** adjunto en propuestas para proyectos de modelado de datos.
**LinkedIn:** rara vez sola — mejor combinada con el diagrama ER.
**Entrevista:** para hablar de organización y convención de nombres.

## 4. Custom Objects

**Demuestra:** los 7 objetos custom con relaciones reales (Master-Detail
donde correspondía, Lookup en el resto) — la decisión, no solo el resultado.
**Cuándo:** cuando el pitch es específicamente sobre diseño de datos.
**Cliente:** clientes que necesitan un modelo de datos custom complejo
(fulfillment, provisioning, cualquier proceso con líneas de detalle).
**Fiverr:** gig de "Data Model Design" o "Custom Objects Architecture".
**Upwork:** proyectos que piden explícitamente "custom objects" en el brief.
**LinkedIn:** post técnico explicando por qué Master-Detail vs. Lookup en
cada caso (usar `PORTFOLIO/architecture/decision-log.md`, punto 1, como base).
**Entrevista:** la pregunta clásica "¿cuándo usás Master-Detail vs. Lookup?"
— tenés un ejemplo real, no hipotético.

## 5. Record Types

**Demuestra:** categorización real de procesos (Service Order: New/Upgrade/
Cancellation; Case: 4 tipos con un Support Process compartido).
**Cuándo:** cuando el cliente tiene un proceso con variantes (distintos
tipos de caso, distintos tipos de orden).
**Cliente:** service desks, empresas con procesos de venta con variantes.
**Fiverr:** gig de "Process Automation" o "Case Management Setup".
**Upwork:** proyectos de Service Cloud.
**LinkedIn:** poco autónomo — combinar con Validation Rules o Flow Builder.
**Entrevista:** para explicar cuándo un Business Process compartido tiene
más sentido que uno por Record Type (ver decision-log, aunque ese punto no
está ahí — está en ARCHITECTURE.md, sección "Standard object customizations").

## 6. Validation Rules

**Demuestra:** lógica de negocio real, no solo "campo requerido" — la regla
de Discount Approval con roll-up, la de Resolution Summary condicionada por
Record Type.
**Cuándo:** cuando el cliente quiere ver que entendés reglas condicionales,
no solo validaciones triviales.
**Cliente:** clientes con procesos de aprobación o compliance.
**Fiverr:** gig de "Business Logic & Validation Rules".
**Upwork:** proyectos que mencionan "data quality" o "approval process".
**LinkedIn:** post mostrando la fórmula + explicando el shadow-field pattern
(decision-log punto 2) — este es contenido técnico fuerte, poco común.
**Entrevista:** para la pregunta "¿cómo validás algo que depende de un
objeto relacionado por Lookup?" — respuesta con evidencia real.

## 7. Permission Sets

**Demuestra:** 10 permission sets de propósito único en vez de 3 perfiles
gigantes — la práctica moderna recomendada por Salesforce.
**Cuándo:** cuando el cliente todavía usa Profiles para todo (muy común) y
querés mostrar el enfoque correcto.
**Cliente:** cualquier org mediana/grande con más de 3 roles distintos.
**Fiverr:** gig de "Security & Access Model Audit".
**Upwork:** proyectos de "permission cleanup" o migración de Profiles a
Permission Sets.
**LinkedIn:** post educativo — "por qué dejé de usar Profiles para permisos
funcionales" con este ejemplo real.
**Entrevista:** pregunta muy común en entrevistas de Salesforce Admin/Architect
senior — tenés 10 ejemplos reales, no una respuesta de memoria.

## 8. Permission Set Groups

**Demuestra:** composición — cómo PSGs combinan Permission Sets sin
duplicar permisos (ver PSG_Provisioning_Lead = Specialist + incremento).
**Cuándo:** seguido de Permission Sets, como el "siguiente nivel".
**Cliente:** igual que Permission Sets, pero para clientes ya familiarizados
con el concepto.
**Fiverr/Upwork:** mismo contexto que #7.
**LinkedIn:** el diagrama de `PORTFOLIO/diagrams/security-model.md` funciona
mejor que la captura sola acá — combinarlos.
**Entrevista:** para demostrar que entendés la diferencia entre "sumar
permisos" y "duplicar permisos" — un error común en admins junior.

## 9. Queues

**Demuestra:** ruteo de trabajo real (Tier 1/Tier 2/Provisioning/Billing
Disputes) ligado a objetos custom, no solo a Case.
**Cuándo:** contexto de service desk o fulfillment operativo.
**Cliente:** service desks, equipos de operaciones.
**Fiverr:** gig de "Service Cloud Setup" o "Case Routing".
**Upwork:** proyectos de "case assignment" o "work distribution".
**LinkedIn:** poco autónomo — combinar con el diagrama de automatización.
**Entrevista:** para hablar de Queue vs. Assignment Rule vs. Flow-based
routing y cuándo elegís cada uno.

## 10. Public Groups

**Demuestra:** agrupación por función (Escalation Reviewers) y por región
(Regional Sales North/South) — la base de las Sharing Rules.
**Cuándo:** siempre junto con Sharing Rules, nunca sola.
**Cliente:** orgs con estructura regional o de escalamiento.
**Fiverr/Upwork:** igual que Sharing Rules (#11).
**LinkedIn:** combinar ambas en un mismo post/carrusel.
**Entrevista:** para explicar Public Group vs. Role vs. Queue — otra
pregunta clásica con respuesta demostrable.

## 11. Sharing Rules

**Demuestra:** las 3 políticas de sharing con su razón de negocio explícita
(no solo "compartido con grupo X" sino _por qué_).
**Cuándo:** cuando el pitch es específicamente sobre modelo de seguridad.
**Cliente:** orgs con visibilidad de datos compleja (multi-región,
multi-equipo, escalamiento cruzado).
**Fiverr:** gig de "Sharing & Visibility Architecture".
**Upwork:** proyectos que mencionan "data visibility" o "who can see what".
**LinkedIn:** el contenido más fuerte de todo el set — "por qué Private OWD

- 3 sharing rules en vez de Public Read/Write" es un post técnico real.
  **Entrevista:** la pregunta de seguridad más común en cualquier entrevista
  de Salesforce — tenés un ejemplo completo, justificado, con diagrama.

## 12. Role Hierarchy

**Demuestra:** estructura organizacional de 11 roles en 3 ramas (Sales /
Service Delivery / Support) debajo de un CEO — jerarquía real, no un mockup
de 3 cajas.
**Cuándo:** contexto de estructura organizacional o reporting.
**Cliente:** cualquier org mediana/grande.
**Fiverr:** gig de "Org-Wide Defaults & Role Hierarchy Setup".
**Upwork:** proyectos de "sales territory" o "reporting structure".
**LinkedIn:** imagen fuerte y muy legible — buena para portada de carrusel.
**Entrevista:** para explicar cómo la jerarquía de roles interactúa con
Sharing Rules y OWD (con el diagrama de seguridad como apoyo).

## 13. Lightning Record Page

**Demuestra:** un record page funcional estándar de Salesforce — usado con
honestidad, no maquillado.
**Cuándo:** contexto donde el cliente pregunta por UI/UX de registros.
**Cliente:** cualquiera, pero es la imagen más "genérica" del set.
**Fiverr/Upwork:** de apoyo, no como pieza principal.
**LinkedIn:** poco recomendable como imagen aislada.
**Entrevista:** si preguntan por qué no hay páginas custom, la respuesta
honesta ya está escrita (decision-log punto 7) — usarla tal cual, transmite
criterio técnico real en vez de inventar una excusa.

## 14. Reports

**Demuestra:** 6 reportes con propósito operativo real (pipeline, MRR,
tareas abiertas, casos escalados) — no reportes de ejemplo genéricos.
**Cuándo:** contexto de reporting o BI liviano dentro de Salesforce.
**Cliente:** cualquier org que necesite visibilidad operativa sin comprar
una herramienta de BI aparte.
**Fiverr:** gig de "Reports & Dashboards".
**Upwork:** proyectos de "reporting" o "analytics setup".
**LinkedIn:** combinar con el Dashboard, no publicar sola.
**Entrevista:** para hablar de Summary vs. Tabular vs. Matrix y cuándo
usás cada formato — tenés los 3 tipos representados.

## 15. Dashboard

**Demuestra:** la pieza visual más fuerte del portfolio — 5 componentes,
4 tipos de gráfico distintos, datos consistentes entre sí.
**Cuándo:** siempre que necesites UNA imagen que "venda" capacidad técnica
de un vistazo.
**Cliente:** decision-makers no técnicos que van a mirar 3 segundos y
decidir si siguen leyendo.
**Fiverr:** imagen principal de la galería del gig, sin dudarlo.
**Upwork:** primera imagen del portfolio item.
**LinkedIn:** la mejor candidata para post individual con buen copy.
**Entrevista:** para hablar de storytelling con datos — por qué elegiste
Donut para MRR y ColumnStacked para pipeline (audiencia y tipo de pregunta
distintos).

## 16. Flow Builder (canvas)

**Demuestra:** automatización declarativa real con ramas, subflow, y
lógica condicional — la Service Order Fulfillment Orchestration completa.
**Cuándo:** cuando el cliente pregunta específicamente por automatización
sin código.
**Cliente:** clientes que quieren evitar Apex o minimizar deuda técnica.
**Fiverr:** gig de "Flow Automation" — tu gig ya existente, esta es
posiblemente la imagen de mayor impacto de todo el portfolio para ese gig.
**Upwork:** cualquier proyecto que mencione "Flow" o "process automation".
**LinkedIn:** post explicando la decisión de shadow-field (decision-log
punto 2) con el canvas como evidencia visual.
**Entrevista:** llevá el flow real — screen-share del canvas si es posible,
si no esta captura, y explicá el diseño elemento por elemento.

## 17. Approval Process

**Demuestra:** un proceso de aprobación real ligado a un roll-up summary,
no un ejemplo de manual.
**Cuándo:** cuando el cliente menciona "necesito que esto pase por
aprobación antes de..." — la pregunta que más gatilla este pitch.
**Cliente:** ventas con descuentos, compras, cualquier proceso con umbral.
**Fiverr:** gig de "Approval Processes & Discount Governance".
**Upwork:** proyectos de "approval workflow" o "discount approval".
**LinkedIn:** combinar con el diagrama de automatización (flow 5).
**Entrevista:** para explicar por qué el approver es `adhoc` en vez de un
usuario fijo (decision-log punto 4) — muestra criterio, no solo ejecución.

## 18. Setup Overview

**Demuestra:** la vista general de Setup — mucho volumen de configuración
visible de un vistazo (barra lateral con todas las categorías usadas).
**Cuándo:** cierre de una galería, nunca como apertura.
**Cliente:** cualquiera; es de apoyo, no de venta.
**Fiverr/Upwork:** última imagen de la galería, si el límite de imágenes
lo permite.
**LinkedIn:** no recomendable sola.
**Entrevista:** no se usa — es la menos específica de las 18.

---

## Reglas generales de uso

- **Nunca publiques una sola captura de Setup sin contexto.** Cada una
  necesita 1-2 líneas explicando qué mirar — un reclutador o cliente no
  va a inferir el detalle técnico por sí solo.
- **Para Fiverr:** priorizá #15 (Dashboard), #16 (Flow Builder), #11
  (Sharing Rules) — son las que más se acercan a "resultado" en vez de
  "configuración".
- **Para Upwork:** las propuestas se leen rápido — usá 1-2 imágenes
  máximo por propuesta, elegidas específicamente según el brief del
  cliente (ver la columna "cuándo usarla" de cada pantalla arriba).
- **Para LinkedIn:** un carrusel de 3-5 imágenes con un ángulo narrativo
  ("por qué elegí X en vez de Y") funciona mejor que una imagen suelta.
  El `PORTFOLIO/architecture/decision-log.md` ya tiene 8 ángulos narrativos
  listos para convertir en posts.
- **Para entrevistas técnicas:** llevá el repo completo, no solo capturas
  — la ventaja real de este proyecto es que cada decisión está documentada
  y podés navegar el código en vivo si te lo piden.

## Qué falta para que esto esté 100% listo

Las 18 capturas de `PORTFOLIO/screenshots/` no existen todavía — ver
`PORTFOLIO/deployment/README.md` para los pasos exactos (conectar un Dev
Hub, desplegar, cargar datos, capturar). Es la única pieza pendiente de
todo este portfolio.
