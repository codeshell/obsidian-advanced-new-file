import { normalizePath } from 'obsidian';

interface ParsedPath {
  /** The full directory path such as '/home/user/dir' or 'folder/sub' */
  dir: string;
  /** The file name without extension */
  name: string;
  /** The file extension (with the dot), empty string if no extension */
  ext: string;
}

export const path = {
  /**
   * Parses the file path into a directory, file name, and extension.
   * If the path string does not include a file name, it will default to
   * 'Untitled'.
   *
   * @example
   * parse('/one/two/file name')
   * // ==> { dir: '/one/two', name: 'file name', ext: '' }
   *
   * parse('/one/two/file.canvas')
   * // ==> { dir: '/one/two', name: 'file', ext: '.canvas' }
   *
   * parse('\\one\\two\\file name.md')
   * // ==> { dir: '/one/two', name: 'file name', ext: '.md' }
   *
   * parse('')
   * // ==> { dir: '', name: 'Untitled', ext: '' }
   *
   * parse('/one/two/')
   * // ==> { dir: '/one/two/', name: 'Untitled', ext: '' }
   */
  parse(pathString: string): ParsedPath {
    const normalizedPath = normalizePath(pathString);
    const lastSlashIndex = normalizedPath.lastIndexOf('/');

    let dir = '';
    let fileName = '';

    if (lastSlashIndex >= 0) {
      dir = normalizedPath.substring(0, lastSlashIndex + 1);
      fileName = normalizedPath.substring(lastSlashIndex + 1);
    } else {
      fileName = normalizedPath;
    }

    fileName = fileName || 'Untitled';

    // Extract extension from filename
    const lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex > 0 && lastDotIndex < fileName.length - 1) {
      // Has extension (dot is not at the beginning or end)
      return {
        dir,
        name: fileName.substring(0, lastDotIndex),
        ext: fileName.substring(lastDotIndex),
      };
    } else {
      // No extension
      return {
        dir,
        name: fileName,
        ext: '',
      };
    }
  },

  /**
   * Joins multiple strings into a path using Obsidian's preferred format.
   * The resulting path is normalized with Obsidian's `normalizePath` func.
   * - Converts path separators to '/' on all platforms
   * - Removes duplicate separators
   * - Removes trailing slash
   */
  join(...strings: string[]): string {
    const parts = strings.map((s) => String(s).trim()).filter((s) => s != null);
    return normalizePath(parts.join('/'));
  },
};
