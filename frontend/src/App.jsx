import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";

const FIELD_META = {
  N: { label: "Nitrogen", unit: "kg/ha", icon: "🌿" },
  P: { label: "Phosphorus", unit: "kg/ha", icon: "🪨" },
  K: { label: "Potassium", unit: "kg/ha", icon: "💧" },
  temperature: { label: "Temperature", unit: "°C", icon: "🌡️" },
  humidity: { label: "Humidity", unit: "%", icon: "💦" },
  ph: { label: "Soil pH", unit: "", icon: "⚗️" },
  rainfall: { label: "Rainfall", unit: "mm", icon: "🌧️" },
};

const MEDAL = ["🥇", "🥈", "🥉"];

const containerVariants = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.07 } },
};

const itemVariants = {
  hidden: { opacity: 0, y: 18, scale: 0.97 },
  visible: {
    opacity: 1,
    y: 0,
    scale: 1,
    transition: { duration: 0.4, ease: [0.22, 1, 0.36, 1] },
  },
};

export default function App() {
  // IMPORTANT: store values as STRINGS
  const [form, setForm] = useState({
    N: "50",
    P: "40",
    K: "40",
    temperature: "25",
    humidity: "70",
    ph: "6.5",
    rainfall: "120",
  });

  const [result, setResult] = useState([]);
  const [loading, setLoading] = useState(false);
  const [dark, setDark] = useState(false);

  const predict = async () => {
    try {
      setLoading(true);
      setResult([]);

      // Convert to numbers ONLY here
      const numericForm = Object.fromEntries(
        Object.entries(form).map(([k, v]) => [k, Number(v)]),
      );

      const res = await fetch("http://localhost:8000/predict", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(numericForm),
      });

      const data = await res.json();
      setResult(data.sort((a, b) => b.suitability - a.suitability));
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className={dark ? "dark" : ""}>
      <div className="min-h-screen relative overflow-hidden bg-linear-to-br from-green-50 via-emerald-50 to-teal-50 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950 transition-colors duration-500">
        {/* Animated background blobs */}
        <motion.div
          className="pointer-events-none absolute -top-40 -left-40 w-120 h-120 rounded-full bg-green-300/25 dark:bg-green-900/15 blur-3xl"
          animate={{ scale: [1, 1.15, 1], opacity: [0.5, 0.8, 0.5] }}
          transition={{ duration: 9, repeat: Infinity, ease: "easeInOut" }}
        />
        <motion.div
          className="pointer-events-none absolute -bottom-40 -right-40 w-120 h-120 rounded-full bg-teal-300/25 dark:bg-teal-900/15 blur-3xl"
          animate={{ scale: [1, 1.2, 1], opacity: [0.4, 0.7, 0.4] }}
          transition={{
            duration: 11,
            repeat: Infinity,
            ease: "easeInOut",
            delay: 2,
          }}
        />
        <motion.div
          className="pointer-events-none absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-150 h-150 rounded-full bg-emerald-200/15 dark:bg-emerald-900/10 blur-3xl"
          animate={{ rotate: [0, 360] }}
          transition={{ duration: 30, repeat: Infinity, ease: "linear" }}
        />

        {/* Dark mode toggle */}
        <motion.button
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.8 }}
          whileHover={{ scale: 1.12, rotate: 12 }}
          whileTap={{ scale: 0.88 }}
          onClick={() => setDark(!dark)}
          aria-label="Toggle dark mode"
          className="fixed top-5 right-5 z-50 p-2.5 rounded-full bg-white/80 dark:bg-gray-800/80 shadow-lg backdrop-blur-md border border-gray-200/70 dark:border-gray-700/70 text-xl cursor-pointer transition-colors duration-300"
        >
          {dark ? "☀️" : "🌙"}
        </motion.button>

        {/* Page content */}
        <div className="relative z-10 flex items-start justify-center min-h-screen py-10 px-4 sm:px-6">
          <motion.div
            initial={{ opacity: 0, y: 48, scale: 0.97 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            transition={{ duration: 0.7, ease: [0.22, 1, 0.36, 1] }}
            className="w-full max-w-5xl"
          >
            {/* Main card */}
            <div className="bg-white/70 dark:bg-gray-900/70 backdrop-blur-2xl rounded-3xl shadow-2xl border border-white/60 dark:border-gray-700/40 overflow-hidden">
              {/* ── Header gradient band ── */}
              <div className="relative bg-linear-to-r from-green-600 via-emerald-500 to-teal-500 px-8 py-10 text-white overflow-hidden">
                {/* Decorative rotating circles */}
                <motion.div
                  className="pointer-events-none absolute -right-16 -top-16 w-56 h-56 rounded-full bg-white/10"
                  animate={{ rotate: 360 }}
                  transition={{
                    duration: 20,
                    repeat: Infinity,
                    ease: "linear",
                  }}
                />
                <motion.div
                  className="pointer-events-none absolute right-20 bottom-0 w-36 h-36 rounded-full bg-white/5"
                  animate={{ rotate: -360 }}
                  transition={{
                    duration: 14,
                    repeat: Infinity,
                    ease: "linear",
                  }}
                />
                <motion.div
                  className="pointer-events-none absolute -left-10 bottom-0 w-40 h-40 rounded-full bg-white/5"
                  animate={{ rotate: 360 }}
                  transition={{
                    duration: 18,
                    repeat: Infinity,
                    ease: "linear",
                  }}
                />

                <motion.div
                  initial={{ opacity: 0, y: -16 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6, delay: 0.3 }}
                  className="relative text-center"
                >
                  <motion.div
                    initial={{ y: -30, opacity: 0 }}
                    whileInView={{ y: 0, opacity: 1 }}
                    transition={{ duration: 0.8, delay: 0.5 }}
                    className="flex items-center justify-center gap-3 mb-1"
                  >
                    <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold tracking-tight drop-shadow-sm">
                      Crop Recommendation System
                    </h1>
                  </motion.div>

                  <p className="text-green-100 mt-2 text-sm sm:text-base font-medium">
                    AI-powered crop predictions from soil &amp; climate data
                  </p>
                </motion.div>
              </div>

              {/* ── Body ── */}
              <div className="p-6 sm:p-8 lg:p-10">
                {/* Section label */}
                <motion.p
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.5 }}
                  className="text-[10px] font-bold uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-5"
                >
                  📊 Soil &amp; Climate Parameters
                </motion.p>

                {/* Staggered input grid */}
                <motion.div
                  variants={containerVariants}
                  initial="hidden"
                  animate="visible"
                  className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5"
                >
                  {Object.keys(form).map((key) => {
                    const meta = FIELD_META[key];
                    return (
                      <motion.div
                        key={key}
                        variants={itemVariants}
                        className="group"
                      >
                        <label className="flex items-center gap-1.5 mb-1.5 text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          <span>{meta.icon}</span>
                          {meta.label}
                        </label>
                        <div className="relative">
                          <input
                            type="text"
                            inputMode="decimal"
                            value={form[key]}
                            onChange={(e) =>
                              setForm({ ...form, [key]: e.target.value })
                            }
                            className="
                              w-full px-4 py-3 pr-16 rounded-xl text-sm font-medium
                              bg-gray-50 dark:bg-gray-800/80
                              border border-gray-200 dark:border-gray-700
                              text-gray-900 dark:text-gray-100
                              focus:outline-none focus:ring-2 focus:ring-emerald-400 focus:border-transparent
                              group-hover:border-emerald-300 dark:group-hover:border-emerald-600
                              transition-all duration-200 shadow-sm
                            "
                          />
                          {meta.unit && (
                            <span className="absolute right-3 top-1/2 -translate-y-1/2 text-[11px] font-bold text-gray-400 dark:text-gray-500 pointer-events-none select-none bg-gray-100 dark:bg-gray-700 px-1.5 py-0.5 rounded-md">
                              {meta.unit}
                            </span>
                          )}
                        </div>
                      </motion.div>
                    );
                  })}
                </motion.div>

                {/* ── Predict button ── */}
                <motion.div
                  initial={{ opacity: 0, y: 12 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.75 }}
                  className="mt-8"
                >
                  <motion.button
                    onClick={predict}
                    disabled={loading}
                    whileHover={!loading ? { scale: 1.02, y: -2 } : {}}
                    whileTap={!loading ? { scale: 0.97 } : {}}
                    className={`
                      relative w-full py-4 rounded-2xl text-base sm:text-lg font-bold text-white
                      bg-linear-to-r from-green-500 via-emerald-500 to-teal-500
                      shadow-lg shadow-emerald-500/25 overflow-hidden
                      transition-all duration-300
                      ${loading ? "cursor-not-allowed opacity-80" : "cursor-pointer hover:shadow-emerald-500/40 hover:shadow-xl"}
                    `}
                  >
                    {/* Shine sweep on hover */}
                    {!loading && (
                      <motion.span
                        className="absolute inset-0 -skew-x-12 bg-linear-to-r from-transparent via-white/25 to-transparent"
                        initial={{ x: "-200%" }}
                        whileHover={{ x: "250%" }}
                        transition={{ duration: 0.65, ease: "easeInOut" }}
                      />
                    )}
                    <span className="relative flex items-center justify-center gap-2.5">
                      {loading ? (
                        <>
                          <motion.span
                            className="w-5 h-5 border-2 border-white/40 border-t-white rounded-full"
                            animate={{ rotate: 360 }}
                            transition={{
                              duration: 0.75,
                              repeat: Infinity,
                              ease: "linear",
                            }}
                          />
                          Analyzing soil data…
                        </>
                      ) : (
                        <>
                          <span>🔍</span>
                          Predict Best Crops
                        </>
                      )}
                    </span>
                  </motion.button>
                </motion.div>

                {/* ── Results ── */}
                <AnimatePresence>
                  {result.length > 0 && (
                    <motion.div
                      key="results"
                      initial={{ opacity: 0, y: 24 }}
                      animate={{ opacity: 1, y: 0 }}
                      exit={{ opacity: 0, y: -12 }}
                      transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
                      className="mt-10"
                    >
                      <div className="flex items-center gap-3 mb-5">
                        <span className="text-2xl">🌱</span>
                        <h2 className="text-xl sm:text-2xl font-extrabold text-gray-800 dark:text-gray-100">
                          Recommended Crops
                        </h2>
                        <span className="ml-auto text-xs font-bold px-3 py-1 rounded-full bg-emerald-100 dark:bg-emerald-900/40 text-emerald-700 dark:text-emerald-300">
                          {result.length} crops
                        </span>
                      </div>

                      <motion.div
                        variants={containerVariants}
                        initial="hidden"
                        animate="visible"
                        className="grid grid-cols-1 sm:grid-cols-2 gap-4"
                      >
                        {result.map((r, idx) => (
                          <motion.div
                            key={r.crop}
                            variants={itemVariants}
                            whileHover={{ y: -4, scale: 1.015 }}
                            className={`
                              relative rounded-2xl p-5 border overflow-hidden cursor-default
                              transition-shadow duration-300
                              ${
                                idx === 0
                                  ? "bg-linear-to-br from-amber-50 to-yellow-50 dark:from-amber-900/20 dark:to-yellow-900/15 border-amber-200 dark:border-amber-700/40 shadow-md shadow-amber-100 dark:shadow-none hover:shadow-amber-200/60 dark:hover:shadow-none"
                                  : "bg-white/60 dark:bg-gray-800/50 border-gray-200 dark:border-gray-700/60 shadow-sm hover:shadow-md dark:hover:shadow-gray-900/50"
                              }
                            `}
                          >
                            {/* Gold corner accent for top result */}
                            {idx === 0 && (
                              <div className="absolute top-0 right-0 w-20 h-20 bg-amber-400/10 rounded-bl-[3rem]" />
                            )}

                            <div className="flex items-center justify-between mb-3.5">
                              <div className="flex items-center gap-2.5">
                                <span className="text-2xl">
                                  {MEDAL[idx] ?? "🌿"}
                                </span>
                                <span className="font-extrabold text-lg capitalize text-gray-800 dark:text-gray-100">
                                  {r.crop}
                                </span>
                              </div>
                              <span
                                className={`
                                text-sm font-extrabold px-3 py-1 rounded-full
                                ${
                                  idx === 0
                                    ? "bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-300"
                                    : "bg-emerald-100 dark:bg-emerald-900/40 text-emerald-700 dark:text-emerald-300"
                                }
                              `}
                              >
                                {r.suitability.toFixed(1)}%
                              </span>
                            </div>

                            {/* Animated progress bar */}
                            <div className="w-full bg-gray-200/80 dark:bg-gray-700 rounded-full h-2.5 overflow-hidden">
                              <motion.div
                                className={`h-2.5 rounded-full ${
                                  idx === 0
                                    ? "bg-linear-to-r from-amber-400 to-yellow-500"
                                    : "bg-linear-to-r from-green-500 to-emerald-500"
                                }`}
                                initial={{ width: 0 }}
                                animate={{
                                  width: `${Math.min(r.suitability, 100)}%`,
                                }}
                                transition={{
                                  duration: 1.1,
                                  delay: idx * 0.1 + 0.2,
                                  ease: [0.22, 1, 0.36, 1],
                                }}
                              />
                            </div>
                          </motion.div>
                        ))}
                      </motion.div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            </div>

            {/* Footer */}
            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.1 }}
              className="text-center text-xs text-gray-400 dark:text-gray-600 mt-5 pb-4"
            >
              Intelligent Crop Recommendation System
            </motion.p>
          </motion.div>
        </div>
      </div>
    </div>
  );
}
