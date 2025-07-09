mkdir mi-primer-ci-cd
cd mi-primer-ci-cd
git init
echo "# Mi Primer CI/CD" > README.md
git add .
git commit -m "Inicio de proyecto"
mkdir -p .github/workflows
touch ./.github/workflows/hola-mundo.yml
git remote add origin https://github.com/TU-USUARIO/mi-primer-ci-cd.git
git branch -M main
git push -u origin main