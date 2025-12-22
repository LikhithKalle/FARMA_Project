/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#13EC6A',
        dark: '#0D1C13',
        secondary: '#1A3826',
      }
    },
  },
  plugins: [],
}
