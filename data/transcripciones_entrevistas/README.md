# Transcripciones de Entrevistas

Esta carpeta contiene los templates y transcripciones de las 3 entrevistas realizadas para el estudio cualitativo del Capítulo IV.

## Archivos

- `Entrevista_E1_Template.md` - Template para el participante E1
- `Entrevista_E2_Template.md` - Template para el participante E2
- `Entrevista_E3_Template.md` - Template para el participante E3

## Instrucciones de uso

### Antes de la entrevista

- Revisar el template correspondiente (E1, E2 o E3)
- Imprimir la `GuiaEntrevista.md` (ubicada en `docs/instrumento_entrevista/`)
- Preparar grabadoras y materiales según `ProtocoloAplicacion.md`

### Durante la entrevista

- Grabar el audio completo

- Tomar notas de campo sobre:
  - Lenguaje corporal
  - Expresiones faciales
  - Tono de voz
  - Énfasis o gestos significativos
  - Pausas importantes
  - Emociones observables

### Después de la entrevista (máximo 72 horas)

#### Transcripción verbatim

1. **Abrir el template correspondiente** (E1, E2 o E3)

2. **Completar los campos iniciales:**
   - Fecha, duración, modalidad, lugar, horarios
   - Datos generales del participante
   - Notas iniciales del contexto

3. **Transcribir cada pregunta:**
   - Copiar **textualmente** las respuestas del entrevistado
   - **IMPORTANTE:** Transcribir palabra por palabra, incluyendo:
     - Pausas: usar [...] para pausas significativas
     - Énfasis: usar **negritas** o _cursivas_
     - Risas, suspiros: [ríe], [suspira]
     - Dudas o titubeos: ehh, mmm, este...

4. **Agregar observaciones:**
   - En cada `[NOTAS DE OBSERVACIÓN]`:
     - _Lenguaje corporal_: "se inclina hacia adelante", "cruza los brazos"
     - _Emociones_: "entusiasmo evidente", "frustración", "nostalgia"
     - _Tono de voz_: "baja el tono", "se acelera al hablar"
     - _Gestos_: "señala con las manos", "hace un gesto de comillas"

5. **Marcar probes aplicados:**
   - Si usó una pregunta probe, marcar [X] en el checkbox
   - Transcribir la respuesta correspondiente

6. **Completar secciones finales:**
   - Notas post-entrevista
   - Aspectos técnicos
   - Reflexiones del investigador

#### Ejemplo de transcripción correcta

```markdown
**ENTREVISTADOR:** ¿Cómo organiza los personajes de sus proyectos durante la pre-escritura?

**E1:** Bueno, yo [...] normalmente uso un cuaderno físico al principio. Ahí voy anotando las características básicas, ¿viste? Nombre, edad, ocupación. Pero después, cuando ya tengo más claro el personaje, paso todo a Google Docs porque es más fácil de organizar y no pierdo nada [ríe].

**[NOTAS DE OBSERVACIÓN]:** Se inclina hacia adelante al hablar del cuaderno, lo toca con cariño. Gesticula mucho con las manos al explicar. Muestra entusiasmo evidente. Pausa reflexiva antes de responder (5 segundos). Tono de voz cálido.

**PROBE aplicado (si/no):** [X] ¿Qué información registra sobre cada personaje?

**E1 (probe):** Mira, depende del proyecto, pero generalmente pongo... mmm... aspectos físicos obvios, como altura, color de pelo. Pero también cosas más psicológicas: qué lo motiva, qué miedos tiene, cuál es su conflicto interno. A veces hasta le invento una historia de infancia aunque nunca salga en el guion [ríe], porque me ayuda a entender por qué actúa como actúa.

**[NOTAS DE OBSERVACIÓN PROBE]:** Se emociona al hablar de aspectos psicológicos. Hace gestos con las manos como si estuviera "construyendo" al personaje. Sonríe al mencionar inventar historias de infancia. Muy detallista en la respuesta.
```

### Control de calidad

Antes de considerar la transcripción completa, verificar:

- [ ] Fecha y datos generales completos
- [ ] Todas las 26 preguntas transcritas
- [ ] Probes aplicados marcados y transcritos
- [ ] Notas de observación en cada pregunta
- [ ] Sección post-entrevista completada
- [ ] Grabación respaldada en 2 ubicaciones
- [ ] Consentimiento informado digitalizado

### Almacenamiento seguro

**IMPORTANTE - Confidencialidad:**

- **NO** incluir nombres reales en las transcripciones
- Usar solo códigos (E1, E2, E3) o seudónimos
- Almacenar archivos de audio en carpeta protegida con contraseña
- Nombre de archivo audio: `Entrevista_E1_YYYY-MM-DD.mp3`
- Hacer backup en 2 ubicaciones diferentes
- **NO** subir al repositorio público si contiene información identificable

### Una vez completadas las 3 entrevistas

Cuando tengan las 3 transcripciones completas:

1. **Commitear al repositorio:**

   ```bash

   git add data/transcripciones_entrevistas/

   git commit -m "Add interview transcriptions E1, E2, E3"

   git push

   ```

2. **Notificar a Claude** para que proceda con:
   - Lectura exhaustiva de las 3 transcripciones
   - Codificación cualitativa (categorías emergentes)
   - Identificación de patrones comunes y divergentes
   - Completar el Capítulo IV con hallazgos reales

## Referencias

- **Guía de Entrevista:** `docs/instrumento_entrevista/GuiaEntrevista.md`
- **Protocolo de Aplicación:** `docs/instrumento_entrevista/ProtocoloAplicacion.md`
- **Matriz de Operacionalización:** `docs/MatrizOperacionalizacion.md`
- **Template Capítulo IV:** `src/capitulos/04_marco_analitico.tex`

## Notas importantes

1. **Verbatim significa TEXTUAL:** No parafrasear, no corregir gramática, transcribir exactamente como habló el entrevistado
2. **Pausas y silencios son datos:** Una pausa larga antes de responder puede indicar reflexión profunda, incomodidad, o dificultad para verbalizar
3. **Lenguaje corporal complementa:** A veces el cuerpo dice más que las palabras. Una respuesta positiva con brazos cruzados puede indicar ambivalencia
4. **Emociones son evidencia:** La frustración, entusiasmo, nostalgia o resignación al hablar de ciertos temas son hallazgos cualitativos valiosos
5. **Probes enriquecen:** Las preguntas probe permiten profundizar. Si el entrevistado da una respuesta superficial, los probes ayudan a obtener más detalle

## Contacto

Si tienen dudas sobre cómo transcribir algo específico, consulten el `ProtocoloAplicacion.md` sección "Transcripción verbatim".

---

**Última actualización:** Noviembre 2025
