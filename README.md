# disk-space-analyzer

Выводит информацию о занятом дисковом пространстве внутри текущего каталога.

## Использование

Просто запустите это в нужном каталоге:
```
curl -s https://raw.githubusercontent.com/simon-project/disk-space-analyzer/refs/heads/main/dsa.sh  | { content=$(cat); echo "$content" | md5sum | grep -q 67f0bfab03c79cbfb0df6fc8434cae4e && echo "$content" | bash || echo "MD5 checksum mismatch. Will not be executed."; }
```

* * * 

Providing information about disk space used in the current dir. 

## Usage

Just run this in the desired directory:
```
curl -s https://raw.githubusercontent.com/simon-project/disk-space-analyzer/refs/heads/main/dsa.sh  | { content=$(cat); echo "$content" | md5sum | grep -q 67f0bfab03c79cbfb0df6fc8434cae4e && echo "$content" | bash || echo "MD5 checksum mismatch. Will not be executed."; }
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
