// import { flatESLintConfig } from "@eslint/flat-config";

// export default [
//     {
//         files: ['**/*.{js,ts}'], // Вказуємо файли, які слід перевіряти
//         languageOptions: {
//             ecmaVersion: 2021, // ECMAScript версія
//             sourceType: 'module', // Тип модулів
//             parser: '@typescript-eslint/parser', // Парсер для TypeScript
//             parserOptions: {
//                 project: ['tsconfig.json', 'tsconfig.dev.json'], // Вказуємо конфігурації TypeScript
//             },
//             globals: {
//                 es6: true,
//                 node: true,
//             },
//         },
//         plugins: {
//             '@typescript-eslint': require('@typescript-eslint/eslint-plugin'),
//             import: require('eslint-plugin-import'),
//         },
//         rules: {
//             'quotes': ['error', 'double'], // Вимога подвійних лапок
//             'import/no-unresolved': 'off', // Вимкнути правило для нерозв'язаних імпортів
//             'indent': ['error', 2], // Відступ у 2 пробіли
//         },
//     },
// ];

import js from "@eslint/js";
import node from "eslint-plugin-node";
import typescript from "@typescript-eslint/eslint-plugin";
import parser from "@typescript-eslint/parser";

export default [
  js.configs.recommended,
  {
    files: ["**/*.ts", "**/*.js"],
    languageOptions: {
      parser: parser,
      globals: {
        require: "readonly",
        exports: "readonly",
        module: "readonly",
      },
    },
    plugins: {
      "@typescript-eslint": typescript,
      node: node,
    },
    rules: {
      quotes: ["error", "double"],
      "indent": ["error", 2],
      "@typescript-eslint/no-unused-vars": "error",
    },
  },
];
