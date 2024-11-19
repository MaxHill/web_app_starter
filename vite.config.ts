import { defineConfig } from "vite";
import { extname, relative } from "path";
import { fileURLToPath } from "node:url";
import { glob } from "glob";

export default defineConfig({
    publicDir: "public",
    build: {
        cssCodeSplit: true,
        manifest: true,
        rollupOptions: {
            external: ["react", "react/jsx-runtime"],
            input: Object.fromEntries(
                glob.sync("src/**/*.{ts,tsx,css}").map((file) => [
                    // The name of the entry point
                    // lib/nested/foo.ts becomes nested/foo
                    relative("src", file.slice(0, file.length - extname(file).length)),
                    // The absolute path to the entry file
                    // src/nested/foo.ts becomes /project/lib/nested/foo.ts
                    fileURLToPath(new URL(file, import.meta.url)),
                ]),
            ),
        },
        sourcemap: true,
    },
});
