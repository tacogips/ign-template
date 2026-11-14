/**
 * @ign-var:PROJECT_NAME@ - Main entry point
 *
 * @ign-var:DESCRIPTION@
 */

import { greet } from "./lib";

function main(): void {
  const message = greet("World");
  console.log(message);
}

main();
