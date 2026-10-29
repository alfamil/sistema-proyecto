/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
    "./*.{js,ts,jsx,tsx}"
  ],
  theme: {
    extend: {
      colors: {
        pdvsa: {
          red: '#c8102e',
          blue: '#002f6c',
          gold: '#cfa935',
          dark: '#0f172a'
        }
      }
    },
  },
  plugins: [],
}

