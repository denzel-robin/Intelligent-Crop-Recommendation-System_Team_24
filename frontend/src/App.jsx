import { useState } from "react";

const FIELD_META = {
  N: { label: "Nitrogen (N)", unit: "kg/ha" },
  P: { label: "Phosphorus (P)", unit: "kg/ha" },
  K: { label: "Potassium (K)", unit: "kg/ha" },
  temperature: { label: "Temperature", unit: "°C" },
  humidity: { label: "Humidity", unit: "%" },
  ph: { label: "Soil pH", unit: "" },
  rainfall: { label: "Rainfall", unit: "mm" },
};

export default function App() {
  // 🔥 IMPORTANT: store values as STRINGS
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

  const predict = async () => {
    try {
      setLoading(true);
      setResult([]);

      // Convert to numbers ONLY here
      const numericForm = Object.fromEntries(
        Object.entries(form).map(([k, v]) => [k, Number(v)])
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
    <div className="min-h-screen bg-gradient-to-br from-green-200 via-emerald-100 to-white flex items-center justify-center p-6">
      <div className="w-full max-w-5xl bg-white/80 backdrop-blur-xl rounded-[2rem] shadow-2xl p-10">

        {/* Header */}
        <div className="mb-10 text-center">
          <h1 className="text-5xl font-extrabold text-green-700">
            🌱 Crop Recommendation System
          </h1>
          <p className="text-gray-600 mt-3 text-lg">
            Smart AI-based crop prediction using soil & climate data
          </p>
        </div>

        {/* Inputs */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
          {Object.keys(form).map((key) => (
            <div key={key}>
              <label className="block mb-2 text-sm font-semibold text-gray-700">
                {FIELD_META[key].label}
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
                    w-full px-4 py-3 pr-14
                    rounded-xl border border-gray-300
                    bg-white shadow-sm
                    focus:ring-2 focus:ring-green-400 focus:border-green-400
                    transition-all duration-300
                  "
                />

                {FIELD_META[key].unit && (
                  <span
                    className="
                      absolute right-4 top-1/2 -translate-y-1/2
                      text-gray-400 text-sm
                      pointer-events-none select-none
                    "
                  >
                    {FIELD_META[key].unit}
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Button */}
        <button
          onClick={predict}
          disabled={loading}
          className={`
            mt-12 w-full py-4 rounded-2xl text-xl font-bold text-white
            bg-gradient-to-r from-green-500 to-emerald-600
            hover:from-green-600 hover:to-emerald-700
            shadow-lg hover:shadow-xl
            transition-all duration-300
            active:scale-95
            ${loading && "opacity-70 cursor-not-allowed"}
          `}
        >
          {loading ? "🌿 Analyzing..." : "🚜 Predict Best Crops"}
        </button>

        {/* Results */}
        {result.length > 0 && (
          <div className="mt-14">
            <h2 className="text-3xl font-bold text-gray-800 mb-6 text-center">
              🌾 Recommended Crops
            </h2>

            <div className="space-y-5">
              {result.map((r, idx) => (
                <div
                  key={r.crop}
                  className="
                    bg-gradient-to-r from-green-50 to-emerald-50
                    border border-green-200 rounded-2xl p-5
                    shadow-sm hover:shadow-md transition
                  "
                >
                  <div className="flex justify-between items-center mb-3">
                    <span className="font-bold text-xl capitalize flex gap-2">
                      {idx === 0 && "🥇"}
                      {idx === 1 && "🥈"}
                      {idx === 2 && "🥉"}
                      {r.crop}
                    </span>

                    <span className="text-green-700 font-extrabold">
                      {r.suitability.toFixed(2)}%
                    </span>
                  </div>

                  <div className="w-full bg-green-200 rounded-full h-3">
                    <div
                      className="
                        bg-gradient-to-r from-green-500 to-emerald-600
                        h-3 rounded-full transition-all duration-700
                      "
                      style={{ width: `${Math.min(r.suitability, 100)}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
