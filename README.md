# Supply Chain Service Level Tracking Analysis and ELT Modelling
Operations Analytics | Python | SQL | dbt | PostgreSQL | Power BI
___

## Project Objective

This project analyses **service level performance** across customers, cities, and products to identify drivers of poor fulfilment and support contract retention decisions.

The goal is to help operations and supply chain teams:

- Track **On-Time**, **In-Full**, and **OTIF** performance
- Compare **actual service levels** vs **customer targets**
- Identify **underperforming customers**, **cities**, and **products**
- Understand **delivery delays** and **fulfilment gaps**
- Build **consistent, scalable metrics** using warehouse data models
- Enable reporting through a **Power BI dashboard**

## Service Level Metrics Defined

- **On-Time Rate (OT%)**: Percentage of orders delivered on or before agreed date
- **In-Full Rate (IF%)**: Percentage of orders delivered with full quantity
- **OTIF Rate**: Percentage of orders that are both On-Time and In-Full
- **Line Fill Rate (LiFR)**:

Proportion of order lines fully fulfilled (binary per line)

- **Volume Fill Rate (VoFR)**:

Total quantity delivered ÷ total quantity ordered (percentage)

- **Delay Days**:

Difference between actual and agreed delivery dates
