
# Instalar e carregar pacotes
if(!require("pacman")) install.packages("pacman")
pacman::p_load(readxl, janitor)


# Converter base de xlsx para rds
base <- readxl::read_excel("./data-raw/Dados_Capão_Orso.xlsx",
                           sheet = "Base",
                           skip = 1)


# Corrigir cabeçalho
base <- 
  base %>%
  janitor::clean_names()


# Salvar em formado RDS
saveRDS(base,
        "./data/dados_capao.rds")
