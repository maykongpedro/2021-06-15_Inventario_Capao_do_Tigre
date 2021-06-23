

# Instalar e carregar pacotes ---------------------------------------------
if(!require("pacman")) install.packages("pacman")
pacman::p_load(readr, tidyverse)

library(ggplot2)
'%>%' <- magrittr::`%>%`

# Carregar base -----------------------------------------------------------
base <- readr::read_rds("./data/dados_capao.rds")


# Explorar dados ----------------------------------------------------------

# tipos de colunas
base %>% dplyr::glimpse()

# quantidade de linhas
nrow(base)


# criar categorias
base_classes <-
  base %>% 
  dplyr::mutate(
    classes_2007 = cut(dap_2007,
                       seq(from = 10, to = 70, by = 5)),
    classes_2010 = cut(dap_2010,
                       seq(from = 10, to = 70, by = 5)),
    classes_2013 = cut(dap_2013,
                       seq(from = 10, to = 70, by = 5)),
    classes_2016 = cut(dap_2016,
                       seq(from = 10, to = 70, by = 5))
    
    )
  
# ver output
view(base_classes)
  

# Visualizar dados --------------------------------------------------------

# criar base para o gráfico
base_classes %>%
  # selecionar colunas das classes
  dplyr::select(classes_2007,
         classes_2010,
         classes_2013,
         classes_2016) %>%
  # transformar em pivot
  tidyr::pivot_longer(cols = 1:4,
               names_to = "ano",
               values_to = "classe") %>%
  # sumarizar
  dplyr::group_by(ano, classe) %>%
  dplyr::summarise(n = dplyr::n()) %>%
  # retirar NA
  dplyr::filter(!is.na(classe)) %>%
  # modificar colunas
  dplyr::mutate(
    # deixar somente os anos
    ano = stringr::str_remove_all(string = ano, pattern = "classes_"),
    # retirar parentesês e colchetes
    classe = stringr::str_remove_all(string = classe, "\\(|\\]"),
    # susbtitir vírgula por traço
    classe = stringr::
      str_replace_all(string = classe,",","-")
    ) %>% 
  
  
# montando o gráfico
  ggplot() +
  geom_col(aes(x = classe, y = n), fill = "#35b779") +
  scale_y_continuous(expand = c(0,0), limits = c(0, 6000)) +
  facet_wrap(~ ano) +
  labs(x = "Classes de diâmetro (cm)", 
       y = "Número de indivíduos",
       caption = "**Dataviz:** @maykongpedro | **Fonte:** UFPR (Laboratório de Inventário Florestal)") +
  ggtitle("Histórico de distribuição diamétrica de um remanescente <br/> de **floresta ombrófila mista**",
          subtitle = paste0("Inventário realizado na floresta Capão do Tigre em Curitiba-PR.\n",
                            "Premissa: DMC de medição foi 10cm de DAP."))+
  theme_bw() +
   theme(
    plot.title = ggtext::element_markdown(),
    plot.caption = ggtext::element_markdown(),
    axis.title.y = element_text(vjust = 2.3),
    axis.title.x = element_text(vjust = -1),
    plot.margin = unit(c(1,1,1,1), "cm")
  )

ggsave("./historico_capao.png",
       dpi = 300)
  
  
  
  
  
  
  
  
  
