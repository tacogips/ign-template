/**
 * @ign-var:PROJECT_NAME@ - Main entry point
 *
 * @ign-var:DESCRIPTION:A TypeScript project@
 */

import { greet } from "./lib";

function main(): void {
  const message = greet("World");
  console.log(message);
}

main();
