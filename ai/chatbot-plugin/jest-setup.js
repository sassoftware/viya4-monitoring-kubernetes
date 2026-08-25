// Jest setup provided by Grafana scaffolding
import './.config/jest-setup';

// Add this import and global for MCP functionality
import { TransformStream } from 'node:stream/web';
import { TextEncoder } from 'util';

// TextEncoder may already be present in your setup
global.TextEncoder = TextEncoder;
// Add this line for MCP TransformStream support
global.TransformStream = TransformStream;
