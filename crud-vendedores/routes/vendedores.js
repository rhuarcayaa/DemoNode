const express = require("express");
const router = express.Router();
const db = require("../db");
// Listar vendedores con opción de búsqueda
router.get("/", async (req, res) => {
  const { busqueda, tipo } = req.query;

  try {
    let rows;
    if (busqueda && tipo) {
      // Realizar búsqueda específica
      switch (tipo) {
        case "id":
          rows = await db.query("CALL sp_busven(?)", [busqueda]);
          break;
        case "nombre":
          rows = await db.query('CALL sp_selven(?, "nombre")', [busqueda]);
          break;
        case "apellido":
          rows = await db.query('CALL sp_selven(?, "apellido")', [busqueda]);
          break;
        default:
          rows = await db.query('CALL sp_selven("", "todos")');
      }
    } else {
      // Listar todos los vendedores
      rows = await db.query('CALL sp_selven("", "todos")');
    }

    res.render("index", {
      vendedores: rows[0][0],
      busqueda: busqueda || "",
      tipo: tipo || "todos",
    });
  } catch (error) {
    console.error("Error al listar vendedores:", error);
    res.status(500).render("index", {
      vendedores: [],
      error: `Error al recuperar vendedores: ${error.message}`,
      busqueda: busqueda || "",
      tipo: tipo || "todos",
    });
  }
});
// Listar vendedores
router.get("/", async (req, res) => {
  try {
    const [rows] = await db.query('CALL sp_selven("", "todos")');
    res.render("index", { vendedores: rows[0] });
  } catch (error) {
    console.error("Error al listar vendedores:", error);
    res.status(500).send("Error al recuperar vendedores");
  }
});

// Formulario de nuevo vendedor
router.get("/nuevo", (req, res) => {
  res.render("nuevo");
});

// Crear nuevo vendedor
router.post("/nuevo", async (req, res) => {
  const { nom_ven, apel_ven, cel_ven } = req.body;
  try {
    const [result] = await db.query("CALL sp_ingven(?, ?, ?)", [
      nom_ven,
      apel_ven,
      cel_ven,
    ]);
    res.json({ success: true, message: "Vendedor creado exitosamente" });
  } catch (error) {
    console.error("Error al crear vendedor:", error);
    res.status(500).send("Error al crear vendedor");
  }
});

// Formulario de edición
router.get("/editar/:id", async (req, res) => {
  try {
    const [rows] = await db.query("CALL sp_busven(?)", [req.params.id]);
    res.render("editar", { vendedor: rows[0][0] });
  } catch (error) {
    console.error("Error al buscar vendedor:", error);
    res.status(500).send("Error al recuperar vendedor");
  }
});

// Actualizar vendedor
router.post("/editar/:id", async (req, res) => {
  const { nom_ven, apel_ven, cel_ven } = req.body;
  const id_ven = req.params.id;
  try {
    await db.query("CALL sp_modven(?, ?, ?, ?)", [
      id_ven,
      nom_ven,
      apel_ven,
      cel_ven,
    ]);
    res.json({ success: true, message: "Vendedor actualizado exitosamente" });
  } catch (error) {
    console.error("Error al modificar vendedor:", error);
    res.status(500).send("Error al modificar vendedor");
  }
});

// Eliminar vendedor
router.get("/eliminar/:id", async (req, res) => {
  try {
    await db.query("CALL sp_delven(?)", [req.params.id]);
    res.json({ success: true, message: "Vendedor eliminado exitosamente" });
  } catch (error) {
    console.error("Error al eliminar vendedor:", error);
    res.status(500).send("Error al eliminar vendedor");
  }
});

module.exports = router;
