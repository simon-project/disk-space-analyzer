# disk-space-analyzer

Выводит информацию о занятом дисковом пространстве внутри текущего каталога.

Позволяет задать максимальную глубину и минимальный размер отображаемых каталогов в результирующем списке.

## Использование

Просто запустите это в нужном каталоге:
```
curl -H "Cache-Control: no-cache" -s https://raw.githubusercontent.com/simon-project/disk-space-analyzer/refs/heads/main/dsa.sh  | { content=$(cat); echo "$content" | md5sum | grep -q 709ba1612d22d396a040a5727c142a8b && echo "$content" | bash || echo "MD5 checksum mismatch. Will not be executed."; }
```

* * * 

Providing information about disk space used in the current dir.

Allows you to set the maximum depth and minimum size of the displayed directories in the resulting list

## Usage

Just run this in the desired directory:
```
curl -H "Cache-Control: no-cache" -s https://raw.githubusercontent.com/simon-project/disk-space-analyzer/refs/heads/main/dsa.sh  | { content=$(cat); echo "$content" | md5sum | grep -q 709ba1612d22d396a040a5727c142a8b && echo "$content" | bash || echo "MD5 checksum mismatch. Will not be executed."; }
```

## P.S.

The author is not a professional developer or a great expert.
The author's developments arise from the emergence of certain tasks and
the absence of ready-made simple solutions, or in cases where such
solutions could not be found or turned out to be too complex or
cumbersome.

You may find here a "bicycle," and not of the most successful design,
reinvented because standard solutions seemed too complicated, or you may
discover "workarounds" that do not look good but nonetheless allow for
movement. Whether to use this is up to you.
